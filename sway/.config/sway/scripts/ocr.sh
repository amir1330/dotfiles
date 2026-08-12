#!/usr/bin/env bash
# ocr.sh — OCR a selected screen region with Tesseract and copy the result.
# Bound to $mod+Ctrl+s in the sway config.

set -euo pipefail

if ! command -v tesseract >/dev/null 2>&1; then
    notify-send "OCR" "Tesseract is not installed. Install with: sudo pacman -S tesseract tesseract-data-eng tesseract-data-rus" -t 4000
    exit 1
fi

REGION=$(slurp 2>/dev/null) || true
[ -n "$REGION" ] || exit 0

TEXT=$(grim -g "$REGION" - | tesseract stdin stdout -l eng+rus 2>/dev/null | sed '/^[[:space:]]*$/d') || true

if [ -z "$TEXT" ]; then
    notify-send "OCR" "No text recognized" -t 3000
    exit 1
fi

printf '%s\n' "$TEXT" | wl-copy

CHARS=$(printf '%s' "$TEXT" | wc -m)
notify-send "OCR" "$CHARS characters copied to clipboard" -t 3000