#!/bin/bash
# Downloads 20 freely-licensed photos for "A Bit of North & A Bit of South"
# from Wikimedia Commons into _incoming/northsouth/ (resized to 1920px wide).
cd "$(dirname "$0")" || exit 1
D=_incoming/northsouth; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Taj Mahal sunrise.jpg"
get hero2    "Alleppey Boat houses.jpg"
get hero3    "Eravikulam National Park-WUS07189.jpg"
get overview "East facade of the Hawa Mahal, Jaipur.jpg"
get day1     "India Gate, New Delhi from West.jpg"
get day2     "20191203 Jama Masjid, Delhi 0707 6468 DxO.jpg"
get day3     "20191204 Moat and walls of Agra Fort 0925 6582.jpg"
get day4     "Keoladeo National Park - Bharatpur 029 (409155591).jpg"
get day5     "Ranthambore National Park morning.jpg"
get day6     "080 Bengal tiger in Ranthambore National Park Photo by Giles Laurent.jpg"
get day7     "Jaipur - Pink City 5.jpg"
get day8     "Jaigarh Fort overlooking the Amer Fort and Maota Lake.jpg"
get day9     "Kochi chinese fishing-net-20080215-01a.jpg"
get day10    "Munnar Tea Plantations-WUS07343-Pano.jpg"
get day11    "Mattupetty Dam reservoir, Munnar (19).jpg"
get day12    "Thekkady, Periyar Lake.JPG"
get day13    "Kathakali performance (2023) 02.jpg"
get day14    "Ashtamudi Lake and Kollam city, Aug 2014.jpg"
get day15    "Varkala Cliff by KS.jpg"
get day16    "Houseboat on Alleppey backwaters (Kerala, India 2023) (52704577484).jpg"
get day17    "Fort Kochi Mattancherry Town.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
