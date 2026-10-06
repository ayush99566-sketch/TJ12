#!/bin/bash
# Downloads 17 freely-licensed photos for "By Road Through High Passes" from Wikimedia Commons
# into _incoming/highpasses/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/highpasses; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Pangong Tso 2.jpg"
get hero2    "Bactrian camels at Hunder sand dunes Ladakh.jpg"
get hero3    "Leh%E2%80%93Manali Highway, Ladakh, India (2016).jpg"
get overview "Thiksey Monastery, Ladakh 15.jpg"
get day1     "View of Qutub Minar (1).jpg"
get day2     "Open hand monument in Capitol Complex.jpg"
get day3     "Pandoh Reservoir - River Beas - Mandi 2014-05-09 2159.JPG"
get day4     "Kullu Valley, Vashisht, Manali, Apples, India.jpg"
get day5     "Keylong, Bhaga, Lahaul and Spiti, India.jpg"
get day6     "River Tsarap From The Gata Loops.jpg"
get day7     "Leh Palace - Leh - Ladakh - View from Shanti Stupa.jpg"
get day8     "Sangam of zanskar and indus (A confluence of rivers).jpg"
get day9     "Khardung La (mountain pass), Ladakh, North India.jpg"
get day10    "Diskit Gompa Nubra valley India.jpg"
get day11    "Pangong Lake, Ladakh, India 07.jpg"
get day12    "Hemis Monastery 02.jpg"
get day13    "Shanti Stupa, Leh, 20180814.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
