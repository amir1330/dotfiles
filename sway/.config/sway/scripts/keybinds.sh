#!/bin/sh

output=$(sed '/^>/d' ~/.config/sway/keybinds.md | while IFS= read -r line; do
  case "$line" in
    "##"*)
      section=$(echo "$line" | sed 's/^## //')
      echo "  ── $section ──"
      ;;
    *\|*)
      key=$(echo "$line" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
      desc=$(echo "$line" | cut -d'|' -f2- | sed 's/^ *//;s/ *$//')
      printf "    %-30s %s\n" "$key" "$desc"
      ;;
    "")
      echo
      ;;
  esac
done)

echo "$output" | yad --text-info --width=750 --height=650 --title="Keybinds" --fontname="monospace 11" --wrap --no-buttons --center
