#!/usr/bin/env bash

STARTFILE="/tmp/screenrecord-start"
MICKFILE="/tmp/screenrecord-mic-start"

START=$(cat "$STARTFILE" 2>/dev/null)
if [ -z "$START" ]; then
    START=$(cat "$MICKFILE" 2>/dev/null)
fi
if [ -z "$START" ]; then
    echo '{"text": "", "class": "idle"}'
    exit 0
fi

NOW=$(date +%s)
ELAPSED=$((NOW - START))

H=$((ELAPSED / 3600))
M=$(( (ELAPSED % 3600) / 60 ))
S=$((ELAPSED % 60))

printf '{"text": "⏺ %02d:%02d:%02d", "class": "recording"}\n' "$H" "$M" "$S"
