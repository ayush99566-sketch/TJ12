#!/bin/bash
# Replaces 3 weaker Temple Run photos (Pondicherry, Madurai palace, Madurai departure). Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/templerun; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
get() {
  local slot="$1" name="${2// /_}"
  curl -sSL -A "$UA" --fail -o "$D/$slot.new" \
    "https://commons.wikimedia.org/wiki/Special:FilePath/${name}?width=1920" \
    && mv -f "$D/$slot.new" "$D/$slot.jpg" && echo "ok    $slot" || echo "FAIL  $slot  ($2)"
  sleep 2
}
get day3 "Pondicherry, Promenade Beach, Rock Beach, India.jpg"
get day6 "Nayakkar Mahal Madurai.jpg"
get day7 "Madurai-Teppakulam-and-Vigneshwar-Temple-at-MyaMandapam.jpg"
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
