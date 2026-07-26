#!/usr/bin/env bash
# Notification history viewer — shows log in rofi

LOG="$HOME/.cache/notification-history.log"

if [[ ! -f "$LOG" ]] || [[ ! -s "$LOG" ]]; then
    notify-send "Notifications" "No notification history"
    exit 0
fi

# Reverse the log (newest first) and show in rofi
selected=$(tac "$LOG" | rofi -dmenu -i \
    -theme ~/.config/rofi/config.rasi \
    -p "notifications" \
    -mesg "Scroll to browse  |  Enter: copy  |  Esc: close" \
    -format "s" \
    -l 15)

if [[ -n "$selected" ]]; then
    # Copy the notification text to clipboard
    echo "$selected" | wl-copy
    notify-send "Copied" "$(echo "$selected" | cut -d'|' -f2- | xargs)"
fi
