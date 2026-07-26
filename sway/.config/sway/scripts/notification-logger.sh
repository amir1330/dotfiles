#!/usr/bin/env bash
# Notification logger — captures notifications via dbus-monitor + awk
# Started by sway on login

LOG="$HOME/.cache/notification-history.log"
mkdir -p "$(dirname "$LOG")"
touch "$LOG"

dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" 2>/dev/null | \
awk '
/member=Notify/ { in_notify=1; str_count=0; next }
in_notify && /string "/ {
    gsub(/.*string "/, ""); gsub(/".*/, "")
    str_count++
    if (str_count == 1) app=$0
    if (str_count == 3) summary=$0
    if (str_count == 4) body=$0
}
in_notify && (/int32/ || /array \[/) {
    if (str_count >= 4) {
        cmd = "date +\"%H:%M\""
        cmd | getline ts
        close(cmd)
        if (summary != "") {
            print "[" ts "] " app " | " summary " | " body
            fflush()
        }
        in_notify=0
    }
}
' >> "$LOG"

# Keep only last 200 entries
tail -200 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
