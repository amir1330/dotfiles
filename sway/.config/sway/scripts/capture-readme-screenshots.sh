#!/usr/bin/env bash
# capture-readme-screenshots.sh
# Capture the gallery images used by README.md.
# Run this inside a live Sway session.

set -euo pipefail

SHOT_DIR="${1:-$HOME/dotfiles/screenshots}"
mkdir -p "$SHOT_DIR"

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "README screenshots" "$1" -t 2000
  else
    echo "[README screenshots] $1"
  fi
}

capture() {
  local name=$1
  shift
  grim "$@" "$SHOT_DIR/$name.png"
}

# 1. Desktop — wait a moment so any previous UI closes.
notify "Capturing desktop in 2s..."
sleep 2
capture desktop

# 2. Rofi — open the drun launcher and wait for render.
swaymsg exec \$menu
sleep 1.5
capture rofi -g "$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "rofi") | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n1)"
swaymsg exec "killall rofi" || true
sleep 0.5

# 3. Waybar — capture the top bar area.
WAYBAR_RECT=$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "waybar") | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n1)
if [ -n "$WAYBAR_RECT" ]; then
  capture waybar -g "$WAYBAR_RECT"
else
  # Fallback: top 32px strip of the first output.
  OUTPUT=$(swaymsg -t get_outputs | jq -r '.[0] | .rect | "\(.x),\(.y) \(.width)x32"')
  capture waybar -g "$OUTPUT"
fi

# 4. Kitty — open a terminal and run fastfetch (or neofetch).
swaymsg exec \$term
sleep 1.5
# Type a fetch command and a small pause so it renders.
swaymsg exec "ydotool type 'fastfetch'" 2>/dev/null || true
sleep 0.5
KITTY_RECT=$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "kitty") | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n1)
capture kitty -g "$KITTY_RECT"
swaymsg exec "killall kitty" || true
sleep 0.5

# 5. Wlogout — open the logout menu.
swaymsg exec wlogout
sleep 1.5
WLOGOUT_RECT=$(swaymsg -t get_tree | jq -r '.. | select(.app_id? == "wlogout") | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | head -n1)
capture wlogout -g "$WLOGOUT_RECT"
swaymsg exec "killall wlogout" || true
sleep 0.5

notify "Done. Images saved to $SHOT_DIR/"
echo "Screenshots saved to $SHOT_DIR/"
ls -lh "$SHOT_DIR"/*.png
