#!/bin/bash
# Downloads 13 freely-licensed photos for "Heavenly Himalayas" from Wikimedia Commons
# into _incoming/himalayas/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/himalayas; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Pangong Tso in eastern Ladakh(Changthang).jpg"
get hero2    "Bactrian camels at Hunder sand dunes Ladakh.jpg"
get hero3    "Thiksey Monastery, Ladakh 02.jpg"
get overview "Hemis Monastery 01.jpg"
get day1     "India Gate, New Delhi.jpg"
get day2     "Aerial view of Himalaya From Delhi Leh Flight Photographed by Sumita Roy.jpg"
get day3     "Leh Palace from Central Asian Museum.jpg"
get day4     "Shanti Stupa Ladakh.jpg"
get day5     "Khardung La (pass), Ladakh, North India.jpg"
get day6     "Maitreya Buddha, Diskit Monastery, Nubra.jpg"
get day7     "Pangong Tso 2.jpg"
get day8     "Hemis Gompa - Prayer Hall.jpg"
get day9     "Indus Valley near Leh.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
