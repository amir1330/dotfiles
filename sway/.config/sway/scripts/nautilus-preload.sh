#!/bin/sh
# Preload Nautilus in background without visible window at login.
# Opens once, then hides window to scratchpad — daemon stays warm for fast Win+E.
set -u

/usr/bin/nautilus --new-window >/dev/null 2>&1 &

# Wait for window (up to 10s), then hide it
for _ in $(seq 1 50); do
    sleep 0.2
    if swaymsg -t get_tree 2>/dev/null | grep -q 'org.gnome.Nautilus'; then
        swaymsg '[app_id="org.gnome.Nautilus"] move scratchpad' >/dev/null 2>&1
        break
    fi
done
