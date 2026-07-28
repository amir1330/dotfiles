#!/bin/sh
sed '/^>/d' ~/.config/sway/keybinds.md | yad --text-info --width=800 --height=700 --title="Keybinds" --fontname="monospace 10" --wrap --no-buttons --center
