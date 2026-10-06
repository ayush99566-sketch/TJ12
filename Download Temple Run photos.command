#!/bin/bash
# Downloads 11 freely-licensed photos for "The Temple Run" from Wikimedia Commons
# into _incoming/templerun/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/templerun; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Madurai Meenakshi Amman Koil Temple Tower.JPG"
get hero2    "Brihadisvara Temple of Thanjavur 01.jpg"
get hero3    "Mamallapuram, Shore Temple, India.jpg"
get overview "Brihadisvara Temple, Thanjavur, Tamil Nadu, India.jpg"
get day1     "Mamallapuram, Arjuna's Penance (9902390324).jpg"
get day2     "Kailasanathar temple, Kanchipuram (6).jpg"
get day3     "Pondicherry-French Quarter-WUS02305.jpg"
get day4     "Maratha palace in Thanjavur.jpg"
get day5     "Srirangam Temple Gopuram View.jpg"
get day6     "Thirumalai Nayakkar Mahal maduri.jpg"
get day7     "Meenakshi Amman Temple, Madurai (10530453014).jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
