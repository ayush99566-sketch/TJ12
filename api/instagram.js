// Vercel serverless function: GET /api/instagram
// Returns your latest Instagram posts as JSON for the homepage photo strip.
// The access token lives ONLY in the Vercel environment variable INSTAGRAM_ACCESS_TOKEN
// (Project -> Settings -> Environment Variables). It is never sent to the browser.
module.exports = async function handler(req, res) {
  const token = process.env.INSTAGRAM_ACCESS_TOKEN;
  if (!token) {
    res.status(200).json({ posts: [], note: 'INSTAGRAM_ACCESS_TOKEN not set' });
    return;
  }
  try {
    const fields = 'id,caption,media_type,media_url,thumbnail_url,permalink,timestamp';
    const url = 'https://graph.instagram.com/me/media?fields=' + fields + '&limit=14&access_token=' + encodeURIComponent(token);
    const r = await fetch(url);
    if (!r.ok) throw new Error('Instagram API ' + r.status);
    const data = await r.json();
    const posts = (data.data || [])
      .map(function (m) {
        var image = m.media_type === 'VIDEO' ? m.thumbnail_url : m.media_url;
        return image ? {
          id: m.id,
          permalink: m.permalink,
          image: image,
          alt: (m.caption || 'Instagram post').replace(/\s+/g, ' ').slice(0, 120),
          video: m.media_type === 'VIDEO'
        } : null;
      })
      .filter(Boolean)
      .slice(0, 12);
    // Cache at Vercel's edge: new posts show up within ~10 minutes.
    res.setHeader('Cache-Control', 's-maxage=600, stale-while-revalidate=3600');
    res.status(200).json({ posts: posts });
  } catch (e) {
    res.setHeader('Cache-Control', 's-maxage=60');
    res.status(200).json({ posts: [], error: 'feed unavailable' });
  }
};
