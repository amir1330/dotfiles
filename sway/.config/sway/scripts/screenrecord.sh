#!/usr/bin/env bash

PIDFILE="/tmp/wf-recorder.pid"
STARTFILE="/tmp/screenrecord-start"
OUTFILE_FILE="/tmp/screenrecord-outfile"
OUTDIR="$HOME/Videos/screenrecords"

mkdir -p "$OUTDIR"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    OUTFILE=$(cat "$OUTFILE_FILE" 2>/dev/null || echo "recording_$(date +%Y-%m-%d_%H-%M-%S).mp4")
    kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE" "$STARTFILE" "$OUTFILE_FILE"
    notify-send "⏹ Recording saved" "$(basename "$OUTFILE")" -t 4000
    pkill -RTMIN+11 waybar 2>/dev/null
else
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTFILE="$OUTDIR/recording_${TIMESTAMP}.mp4"
    echo "$OUTFILE" > "$OUTFILE_FILE"

    LOG="/tmp/screenrecord.log"

    AUDIO_SOURCE=$(pactl list sources short | awk '$2 ~ /\.monitor$/ && $2 !~ /record_mix\.monitor/ {print $2}' | head -1)
    FOCUSED_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

    if [ -n "$AUDIO_SOURCE" ]; then
        wf-recorder -o "$FOCUSED_OUTPUT" --audio="$AUDIO_SOURCE" -f "$OUTFILE" > "$LOG" 2>&1 &
    else
        wf-recorder -o "$FOCUSED_OUTPUT" -f "$OUTFILE" > "$LOG" 2>&1 &
    fi

    PID=$!
    echo "$PID" > "$PIDFILE"
    date +%s > "$STARTFILE"

    sleep 1
    if ! kill -0 "$PID" 2>/dev/null; then
        rm -f "$PIDFILE" "$STARTFILE" "$OUTFILE_FILE" "$OUTFILE"
        notify-send "⏺ Recording failed" "wf-recorder exited immediately. See $LOG" -u critical
        exit 1
    fi

    notify-send "⏺ Recording started" "$FOCUSED_OUTPUT → $(basename "$OUTFILE")" -t 3000
    pkill -RTMIN+11 waybar 2>/dev/null
fi
