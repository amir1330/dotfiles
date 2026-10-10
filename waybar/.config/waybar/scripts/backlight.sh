#!/bin/sh
# backlight.sh — step intel_backlight and push an instant waybar refresh.
# Usage: backlight.sh [up|down]   (no arg: print current level for waybar)
DEV=intel_backlight
case "$1" in
    up) brightnessctl -d "$DEV" set +2% >/dev/null ;;
    down) brightnessctl -d "$DEV" set 2%- >/dev/null ;;
esac
brightnessctl -d "$DEV" -m | awk -F, '{gsub(/%/,"",$4); print "bl " $4 "%"}'
case "$1" in
    up|down) pkill -RTMIN+8 waybar 2>/dev/null ;;
esac
