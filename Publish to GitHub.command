#!/bin/bash
# Double-click to publish all changes in this folder to GitHub (and Vercel).
cd "$(dirname "$0")" || exit 1
if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing new to publish."
else
  git add -A
  git commit -m "Update site $(date '+%Y-%m-%d %H:%M')"
  git push && echo "" && echo "Published! The live site updates in about a minute."
fi
echo ""
read -n 1 -s -r -p "Press any key to close..."
