#!/usr/bin/env bash
# Mic toggle script for waybar custom/mic module

if [ "$1" = "toggle" ]; then
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
  sleep 0.1
fi

mute=$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $2}')

if [ "$mute" = "yes" ]; then
  echo '{"text": "mic", "tooltip": "Mic muted", "class": "muted"}'
else
  echo '{"text": "mic", "tooltip": "Mic on", "class": "on"}'
fi
