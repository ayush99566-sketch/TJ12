#!/bin/bash
# Fetches the Madurai gopuram photo for The Temple Run's first hero image. Double-click to run.
cd "$(dirname "$0")" || exit 1
D=_incoming/templerun; mkdir -p "$D"
UA="TournivalJourneys-site/1.0 (info@tournivaljourneys.com)"
curl -sSL -A "$UA" --fail -o "$D/hero1.new" \
  "https://commons.wikimedia.org/wiki/Special:FilePath/Meenakshi_Amman_Temple,_Madurai_(10530453014).jpg?width=1920" \
  && mv -f "$D/hero1.new" "$D/hero1.jpg" && echo "ok    hero1" || echo "FAIL  hero1"
echo ""; read -n 1 -s -r -p "Done. Tell Claude it finished. Press any key to close..."
