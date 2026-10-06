#!/bin/bash
# Downloads 13 freely-licensed photos for "Golden Triangle & Roaring Ranthambhore" from Wikimedia Commons
# into _incoming/ranthambhore/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/ranthambhore; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Bengal Tiger (Ranthambore National Park).jpg"
get hero2    "Bengal tiger in Ranthambore National Park.jpg"
get hero3    "Fort of Ranthambore as visible from Ranthambore National Park.jpg"
get overview "079 Bengal tiger in Ranthambore National Park Photo by Giles Laurent.jpg"
get day1     "India Gate, New Delhi from West.jpg"
get day2     "Courtyard of Jama Masjid, in Delhi 03.jpg"
get day3     "Agra 19 - Itimad-ud-Daula tomb (41493444235).jpg"
get day4     "RamathraFort 03.jpg"
get day5     "Padam Talao Lake, Ranthambore National Park (2014).jpg"
get day6     "080 Bengal tiger in Ranthambore National Park Photo by Giles Laurent.jpg"
get day7     "Blue Pottery, Jaipur School of Art.jpg"
get day8     "20191218 Jantar Mantar, Jaipur 0906 8983 DxO.jpg"
get day9     "View of Qutub Minar (3).jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
