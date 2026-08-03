#!/usr/bin/env bash
# swappy-run.sh — run swappy with US layout active so its shortcuts work
# regardless of the current keyboard layout, then restore the previous layout.

set -euo pipefail

# Find the first real keyboard's current active layout index.
CURRENT_IDX=$(swaymsg -t get_inputs | jq -r '[.[] | select(.type=="keyboard" and (.name | contains("virtual") | not))][0].xkb_active_layout_index // 0')

# Switch to US layout (index 0) for swappy's English shortcuts.
swaymsg input type:keyboard xkb_switch_layout 0 >/dev/null 2>&1 || true

# Run swappy with all arguments passed through.
# shellcheck disable=SC2068
swappy $@

# Restore the layout that was active before swappy opened.
swaymsg input type:keyboard xkb_switch_layout "$CURRENT_IDX" >/dev/null 2>&1 || true
