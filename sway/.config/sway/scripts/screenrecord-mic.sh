#!/usr/bin/env bash

PIDFILE="/tmp/wf-recorder-mic.pid"
STARTFILE="/tmp/screenrecord-mic-start"
OUTFILE_FILE="/tmp/screenrecord-mic-outfile"
MODULES_FILE="/tmp/screenrecord-mic-modules"
OUTDIR="$HOME/Videos/screenrecords"

MIX_SINK="record_mix"

mkdir -p "$OUTDIR"

unload_mix_modules() {
    if [ -f "$MODULES_FILE" ]; then
        while read -r mod; do
            [ -n "$mod" ] && pactl unload-module "$mod" 2>/dev/null
        done < "$MODULES_FILE"
    fi
    for mod in $(pactl list short modules 2>/dev/null | awk '/record_mix/ {print $1}'); do
        pactl unload-module "$mod" 2>/dev/null
    done
    rm -f "$MODULES_FILE"
}

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    OUTFILE=$(cat "$OUTFILE_FILE" 2>/dev/null || echo "recording_$(date +%Y-%m-%d_%H-%M-%S).mp4")
    kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE" "$STARTFILE" "$OUTFILE_FILE"
    unload_mix_modules
    notify-send "⏹ Recording saved" "$(basename "$OUTFILE")" -t 4000
    pkill -RTMIN+11 waybar 2>/dev/null
else
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTFILE="$OUTDIR/recording_${TIMESTAMP}.mp4"
    echo "$OUTFILE" > "$OUTFILE_FILE"

    unload_mix_modules

    DESKTOP_SOURCE=$(pactl list sources short | grep monitor | head -1 | awk '{print $2}')
    MIC_SOURCE=$(pactl list sources short | awk '$2 !~ /\.monitor$/ {print $2}' | head -1)
    FOCUSED_OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

    MIX_MOD=$(pactl load-module module-null-sink sink_name="$MIX_SINK" sink_properties=device.description="Mic+Desktop Mix" 2>/dev/null)
    if [ -z "$MIX_MOD" ]; then
        rm -f "$OUTFILE_FILE"
        notify-send "⏺ Recording failed" "Could not create mix sink" -u critical
        exit 1
    fi

    MIC_MOD=""
    if [ -n "$MIC_SOURCE" ]; then
        MIC_MOD=$(pactl load-module module-loopback source="$MIC_SOURCE" sink="$MIX_SINK" latency_msec=50 2>/dev/null)
    fi
    DESK_MOD=""
    if [ -n "$DESKTOP_SOURCE" ]; then
        DESK_MOD=$(pactl load-module module-loopback source="$DESKTOP_SOURCE" sink="$MIX_SINK" latency_msec=50 2>/dev/null)
    fi

    if [ -z "$MIC_MOD" ] && [ -z "$DESK_MOD" ]; then
        unload_mix_modules
        rm -f "$OUTFILE_FILE"
        notify-send "⏺ Recording failed" "No audio sources available" -u critical
        exit 1
    fi

    printf '%s\n%s\n%s\n' "$MIX_MOD" "$MIC_MOD" "$DESK_MOD" > "$MODULES_FILE"

    wf-recorder -o "$FOCUSED_OUTPUT" --audio="${MIX_SINK}.monitor" -f "$OUTFILE" > /tmp/screenrecord-mic.log 2>&1 &

    echo $! > "$PIDFILE"
    date +%s > "$STARTFILE"
    notify-send "⏺ Recording started" "$FOCUSED_OUTPUT → $(basename "$OUTFILE") (mic + desktop)" -t 3000
    pkill -RTMIN+11 waybar 2>/dev/null
fi
