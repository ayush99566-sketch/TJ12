#!/bin/bash
# Downloads 14 freely-licensed photos for "Golden Triangle & Rustic Rajasthan" from Wikimedia Commons
# into _incoming/rustic/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/rustic; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Taj Mahal, Agra, India edit2.jpg"
get hero2    "Abhaneri-Chand Baori-17a-Stufenbrunnen-2018-gje.jpg"
get hero3    "Haveli, Mandawa 3.jpg"
get overview "India Mandawa haveli 11 ni.JPG"
get day1     "20191203 Naubat Khana, Red Fort, Delhi 0456 6348 DxO.jpg"
get day2     "Tomb of Safdarjung in Delhi.jpg"
get day3     "Fatehpur Sikri Palace Complex 2018-01-01zo.jpg"
get day4     "View of Taj Mahal from Mehtab Bagh gardens.jpg"
get day5     "Rajasthan-Village life in Mount Abu.jpg"
get day6     "20191218 Fort Nahargarh, Jaipur 1514 9294.jpg"
get day7     "Fatehpur-Dwarkadheesh Temple-20131008.jpg"
get day8     "Golden Haveli - Mandawa - Rajasthan - IMG 2110.jpg"
get day9     "Castle Mandawa -Jhunjhunu District, Mandawa, Rajasthan -IMG 2018.jpg"
get day10    "Lotus Temple-Panoroma-Visit During WCI 2016- IMG 6471.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
