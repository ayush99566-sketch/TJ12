#!/bin/bash
# Downloads 15 freely-licensed photos for "Heritage Streets" from Wikimedia Commons
# into _incoming/heritage/ (resized to 1920px wide). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/heritage; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  if [ -s "$D/$slot.jpg" ]; then echo "have  $slot"; return; fi
  curl -sSL -A "$UA" --fail -o "$D/$slot.jpg" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get hero1    "Mehrangarh Fort 2, Jodhpur, Rajasthan, India.jpg"
get hero2    "20191207 Lake Pichola, City Palace, Udaipur, 1516 7254.jpg"
get hero3    "Jal Mahal Palace in Jaipur, 20191218 1427 9226.jpg"
get overview "20191218 Hawa Mahal (The Palace of Winds) in Jaipur, 1156 9165.jpg"
get day1     "Rashtrapati Bhavan-Delhi-India4445.JPG"
get day2     "View of Qutub Minar (1).jpg"
get day3     "Taj Mahal Tomb at sunrise.JPG"
get day4     "Abhaneri-Chand Baori-13-Stufenbrunnen-2018-gje.jpg"
get day5     "20191218 Jaigarh Fort, Amer, Jaipur 1551 9335.jpg"
get day6     "Pushkar, India, Pushkar Lake and Ghats, Twilight.jpg"
get day7     "Jodhpur, India, Jodhpur old city panorama from Mehrangarh Fort.jpg"
get day8     "20191210 Jaswant Thada, Jodhpur 1242 7961.jpg"
get day9     "Jain Temple Ranakpur.jpg"
get day10    "City Palace Udaipur Rajasthan India.JPG"
get day11    "Sahelion Ki Bari, Udaipur.jpg"
echo ""; ls "$D" | wc -l
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
