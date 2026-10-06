#!/usr/bin/env python3
"""Find and install itinerary-day photos from Pexels, Unsplash and Pixabay.

Two steps, so every photo is checked by eye before it goes on the site:

  python3 tools/fill_photos.py search southern-splendors [--day 5] [--per 3]
      Searches each provider with the day's queries (tools/photo-queries/<tour>.json),
      saves thumbnails plus one contact sheet per day in .photo-candidates/<tour>/.

  python3 tools/fill_photos.py apply southern-splendors 5 pexels-123456
      Downloads that candidate at full size, crops it to 3:2, saves it over
      assets/user-photos/<tour>-day5.jpg and records the photo credit.

API keys are read from the environment (never commit them):
  PEXELS_API_KEY, UNSPLASH_ACCESS_KEY, PIXABAY_API_KEY
"""
import argparse
import io
import json
import os
import sys
import urllib.parse
import urllib.request

from PIL import Image, ImageDraw, ImageOps

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QUERIES_DIR = os.path.join(ROOT, 'tools', 'photo-queries')
CANDIDATES_DIR = os.path.join(ROOT, '.photo-candidates')
PHOTOS_DIR = os.path.join(ROOT, 'assets', 'user-photos')
CREDITS_JSON = os.path.join(PHOTOS_DIR, 'credits.json')
CREDITS_MD = os.path.join(PHOTOS_DIR, 'CREDITS.md')

OUT_SIZE = (1200, 800)  # itinerary images are shown at aspect-ratio 3/2
JPEG_QUALITY = 82
UA = 'TournivalJourneys-photo-tool/1.0'

KEY_NAMES = {
    'pexels': ['PEXELS_API_KEY', 'PEXELS_KEY', 'PEXELS'],
    'unsplash': ['UNSPLASH_ACCESS_KEY', 'UNSPLASH_API_KEY', 'UNSPLASH_KEY', 'UNSPLASH'],
    'pixabay': ['PIXABAY_API_KEY', 'PIXABAY_KEY', 'PIXABAY'],
}


def env_key(provider):
    for name in KEY_NAMES[provider]:
        if os.environ.get(name):
            return os.environ[name]
    return None


def http_get(url, headers=None, timeout=30):
    req = urllib.request.Request(url, headers=dict({'User-Agent': UA}, **(headers or {})))
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read()


def get_json(url, headers=None):
    return json.loads(http_get(url, headers))


# --- providers: each returns a list of normalised candidate dicts -------------

def search_pexels(key, query, per):
    url = 'https://api.pexels.com/v1/search?' + urllib.parse.urlencode(
        {'query': query, 'per_page': per, 'orientation': 'landscape'})
    data = get_json(url, {'Authorization': key})
    return [{
        'id': 'pexels-%s' % p['id'],
        'thumb': p['src']['medium'],
        'full': p['src']['original'] + '?auto=compress&cs=tinysrgb&w=1800',
        'author': p['photographer'],
        'author_url': p['photographer_url'],
        'page': p['url'],
        'desc': p.get('alt') or '',
        'width': p['width'], 'height': p['height'],
    } for p in data.get('photos', [])]


def search_unsplash(key, query, per):
    url = 'https://api.unsplash.com/search/photos?' + urllib.parse.urlencode(
        {'query': query, 'per_page': per, 'orientation': 'landscape'})
    data = get_json(url, {'Authorization': 'Client-ID ' + key, 'Accept-Version': 'v1'})
    return [{
        'id': 'unsplash-%s' % p['id'],
        'thumb': p['urls']['small'],
        'full': p['urls']['raw'] + '&w=1800&q=85&fm=jpg&fit=max',
        'author': p['user']['name'],
        'author_url': p['user']['links']['html'],
        'page': p['links']['html'],
        'download_location': p['links']['download_location'],
        'desc': p.get('alt_description') or p.get('description') or '',
        'width': p['width'], 'height': p['height'],
    } for p in data.get('results', [])]


def search_pixabay(key, query, per):
    url = 'https://pixabay.com/api/?' + urllib.parse.urlencode(
        {'key': key, 'q': query, 'image_type': 'photo', 'orientation': 'horizontal',
         'per_page': max(per, 3), 'safesearch': 'true'})
    data = get_json(url)
    return [{
        'id': 'pixabay-%s' % p['id'],
        'thumb': p['webformatURL'],
        'full': p['largeImageURL'],
        'author': p['user'],
        'author_url': 'https://pixabay.com/users/%s-%s/' % (p['user'], p['user_id']),
        'page': p['pageURL'],
        'desc': p.get('tags') or '',
        'width': p['imageWidth'], 'height': p['imageHeight'],
    } for p in data.get('hits', [])[:per]]


PROVIDERS = {'pexels': search_pexels, 'unsplash': search_unsplash, 'pixabay': search_pixabay}


# --- helpers ------------------------------------------------------------------

def load_queries(tour):
    with open(os.path.join(QUERIES_DIR, tour + '.json')) as f:
        return json.load(f)


def day_dir(tour, day):
    return os.path.join(CANDIDATES_DIR, tour, 'day%s' % day)


def contact_sheet(cands, thumbs, path, title):
    cols, cell_w, cell_h, label_h = 4, 360, 240, 22
    rows = max(1, (len(cands) + cols - 1) // cols)
    sheet = Image.new('RGB', (cols * cell_w, rows * (cell_h + label_h) + 30), 'white')
    draw = ImageDraw.Draw(sheet)
    draw.text((8, 8), title, fill='black')
    for i, (c, im) in enumerate(zip(cands, thumbs)):
        x, y = (i % cols) * cell_w, 30 + (i // cols) * (cell_h + label_h)
        sheet.paste(ImageOps.fit(im, (cell_w - 6, cell_h - 6)), (x + 3, y + 3))
        draw.text((x + 4, y + cell_h + 3), '%d  %s' % (i + 1, c['id']), fill='black')
    sheet.save(path, quality=80)


def cmd_search(args):
    cfg = load_queries(args.tour)
    keys = {p: env_key(p) for p in PROVIDERS}
    active = [p for p, k in keys.items() if k]
    if not active:
        sys.exit('No API keys found. Set one of: ' + ', '.join(n for v in KEY_NAMES.values() for n in v))
    print('Providers:', ', '.join(active))
    days = [str(args.day)] if args.day else sorted(cfg['days'], key=int)
    for day in days:
        spec = cfg['days'][day]
        out = day_dir(args.tour, day)
        os.makedirs(out, exist_ok=True)
        cands, seen = [], set()
        for q in spec['queries']:
            for p in active:
                try:
                    for c in PROVIDERS[p](keys[p], q, args.per):
                        if c['id'] not in seen:
                            seen.add(c['id'])
                            c['query'] = q
                            cands.append(c)
                except Exception as e:  # one provider failing shouldn't stop the run
                    print('  ! %s "%s": %s' % (p, q, e))
        thumbs, kept = [], []
        for c in cands:
            try:
                im = Image.open(io.BytesIO(http_get(c['thumb']))).convert('RGB')
            except Exception as e:
                print('  ! thumb %s: %s' % (c['id'], e))
                continue
            im.save(os.path.join(out, c['id'] + '.jpg'), quality=80)
            thumbs.append(im)
            kept.append(c)
        with open(os.path.join(out, 'candidates.json'), 'w') as f:
            json.dump(kept, f, indent=1)
        sheet = os.path.join(out, 'sheet.jpg')
        contact_sheet(kept, thumbs, sheet, 'Day %s: %s' % (day, spec['title']))
        print('Day %s (%s): %d candidates -> %s' % (day, spec['title'], len(kept), os.path.relpath(sheet, ROOT)))


def update_credits(tour, day, c):
    credits = {}
    if os.path.exists(CREDITS_JSON):
        with open(CREDITS_JSON) as f:
            credits = json.load(f)
    fname = '%s-day%s.jpg' % (tour, day)
    credits[fname] = {k: c[k] for k in ('id', 'author', 'author_url', 'page')}
    with open(CREDITS_JSON, 'w') as f:
        json.dump(dict(sorted(credits.items())), f, indent=1)
    lines = ['# Photo credits', '',
             'Itinerary photos sourced from Pexels, Unsplash and Pixabay under their free licences.', '',
             '| File | Photographer | Source |', '|---|---|---|']
    for name, v in sorted(credits.items()):
        site = v['id'].split('-')[0].capitalize()
        lines.append('| %s | [%s](%s) | [%s](%s) |' % (name, v['author'], v['author_url'], site, v['page']))
    with open(CREDITS_MD, 'w') as f:
        f.write('\n'.join(lines) + '\n')


def cmd_apply(args):
    with open(os.path.join(day_dir(args.tour, args.day), 'candidates.json')) as f:
        cands = {c['id']: c for c in json.load(f)}
    if args.candidate not in cands:
        sys.exit('Unknown candidate %s for day %s' % (args.candidate, args.day))
    c = cands[args.candidate]
    if c['id'].startswith('unsplash-'):
        # Unsplash API guidelines: trigger a download event when a photo is used.
        key = env_key('unsplash')
        if key:
            try:
                http_get(c['download_location'], {'Authorization': 'Client-ID ' + key})
            except Exception as e:
                print('  ! unsplash download ping failed: %s' % e)
    im = Image.open(io.BytesIO(http_get(c['full'], timeout=60)))
    im = ImageOps.exif_transpose(im).convert('RGB')
    im = ImageOps.fit(im, OUT_SIZE, Image.LANCZOS, centering=(0.5, args.focus_y))
    dest = os.path.join(PHOTOS_DIR, '%s-day%s.jpg' % (args.tour, args.day))
    im.save(dest, quality=JPEG_QUALITY, optimize=True, progressive=True)
    update_credits(args.tour, args.day, c)
    print('Saved %s (%d KB) from %s by %s' % (os.path.relpath(dest, ROOT), os.path.getsize(dest) // 1024, c['id'], c['author']))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    s = sub.add_parser('search')
    s.add_argument('tour')
    s.add_argument('--day', type=int)
    s.add_argument('--per', type=int, default=3, help='results per query per provider')
    s.set_defaults(func=cmd_search)
    a = sub.add_parser('apply')
    a.add_argument('tour')
    a.add_argument('day', type=int)
    a.add_argument('candidate')
    a.add_argument('--focus-y', type=float, default=0.5, help='vertical crop focus, 0=top 1=bottom')
    a.set_defaults(func=cmd_apply)
    args = ap.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
