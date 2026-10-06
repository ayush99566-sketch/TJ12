#!/bin/bash
# Downloads 22 freely-licensed photos for "Southern Splendors" from Wikimedia Commons
# into _incoming/southern/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/southern; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Madurai, India.jpg"
get hero2    "Brihadisvara Temple during Maha Shivaratri-WUS03611 (edit).jpg"
get hero3    "Mamallapuram, Shore Temple, India.jpg"
get overview "MEENAKSHI TEMPLE- WEST TOWER.jpg"
get day1     "Marina Beach in Chennai.jpg"
get day2     "Mahabalipuram, Pancha Rathas, Visitors, India.jpg"
get day3     "Kanchi Kailasanathar Temple at Kanchipuram, Tamil Nadu 01.jpg"
get day4     "Pondicherry, Promenade Beach, Rock Beach, India.jpg"
get day5     "Puducherry Dumas Street.JPG"
get day6     "Gangaikonda Cholapuram view.jpg"
get day7     "Darasuram, Airavatesvara Temple, Entrance, India.jpg"
get day8     "Thirumalai Nayakkar Mahal maduri.jpg"
get day9     "Golden Lotus in Meenakshi Amman Temple.jpg"
get day10    "Munnar - Top Station Highway-WUS07295.jpg"
get day11    "Tea plantation hills at sunrise near Kolukkumalai, Kerala.jpg"
get day12    "Spices in a shop Kerala.jpg"
get day13    "Thekkady Forest Trek.JPG"
get day14    "Vembanad Lake at Kumarakom.jpg"
get day15    "Kumarakom backwaters panorama.jpg"
get day16    "Nedumudy - Houseboat.jpg"
get day17    "Paradesi Synagogue - Chandelier.jpg"
get day18    "Marine Drive Kochi 01.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
