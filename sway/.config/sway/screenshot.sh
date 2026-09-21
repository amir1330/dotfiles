#!/bin/sh

case $1 in
  screen) grim - | ~/.config/sway/scripts/swappy-run.sh -f -;;
  region) grim -g "$(slurp)" - | ~/.config/sway/scripts/swappy-run.sh -f - ;;
  window) grim -g "$(
    swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp
  )" - | ~/.config/sway/scripts/swappy-run.sh -f - ;;
  freeze)
    DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$DIR"
    FILE="$DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    TMP=$(mktemp /tmp/screenshot-freeze-XXXXXX.png)
    grim "$TMP"
    mpv --fullscreen --no-audio --no-osc --no-osd-bar --loop-file=no --pause --no-input-default-bindings --keepaspect=no --cursor-autohide=no "$TMP" &
    MPV_PID=$!
    sleep 0.3
    REGION=$(slurp)
    if [ -n "$REGION" ]; then
      X=$(echo "$REGION" | cut -d, -f1)
      Y=$(echo "$REGION" | cut -d, -f2 | cut -d' ' -f1)
      W=$(echo "$REGION" | cut -d' ' -f2 | cut -dx -f1)
      H=$(echo "$REGION" | cut -d' ' -f2 | cut -dx -f2)
      magick "$TMP" -crop "${W}x${H}+${X}+${Y}" +repage "$FILE"
      wl-copy < "$FILE"
      notify-send "Screenshot" "Saved to $FILE" -t 3000
    fi
    kill "$MPV_PID" 2>/dev/null
    rm -f "$TMP"
    ;;
esac
