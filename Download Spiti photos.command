#!/bin/bash
# Downloads 18 freely-licensed Spiti Valley photos from Wikimedia Commons
# into _incoming/spiti/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
mkdir -p _incoming/spiti
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {  # slot  "Commons file name"
  local slot="$1" name="${2// /_}"
  if [ -s "_incoming/spiti/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "_incoming/spiti/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Chandra Taal (Lake), HP, India, D35 7333 nx01.jpg"
get hero2    "Key Monastery - Spiti -Himachal Pradesh MG 6796.jpg"
get hero3    "Dhankar Gompa-20-Klosterburg-gje.jpg"
get overview "Key Gompa monastery, Spiti Valley, Himachal Pradesh, India 02.jpg"
get day1     "Humayun's Tomb, Delhi 1.jpg"
get day2     "Scene at Nek Chand Fantasy Rock Garden - Chandigarh U.T. - India - 02 (25901815083).jpg"
get day3     "Kullu Valley, Beas River near Manali, India.jpg"
get day4     "Hadimba Devi Temple Manali.jpg"
get day5     "Atal Tunnel 01 (cropped).jpg"
get day6     "Kunzum La-29-pass height-choerten-2016-gje.jpg"
get day7     "Dhankar Gompa, Spiti.jpg"
get day8     "Tabo Gompa-12-neuer Gompa-gje.jpg"
get day9     "Langza village and Buddha statue.jpg"
get day10    "Komic village.jpg"
get day11    "Kunzum top.jpg"
get day12    "Solang Valley, Manali.jpg"
get day13    "Beas Valley - Palchan - Kullu 2014-05-10 (edit).jpg"
get day14    "Sukhna Lake Chandigarh Evening.jpg"
echo ""; ls -la _incoming/spiti | head -30
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
