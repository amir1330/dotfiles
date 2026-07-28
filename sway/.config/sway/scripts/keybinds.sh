#!/bin/sh
sed -n '/^[^>]/p' ~/.config/sway/keybinds.md | rofi -dmenu -i -p "Keybinds" -no-custom -lines 50
