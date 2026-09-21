#!/usr/bin/env bash
# Workspace navigation: strict +1/-1 stepping, lower bound 1
# Usage: workspace-nav.sh next|prev

DIR="${1:-next}"

CURRENT=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')

# Guard against empty/non-numeric output
if ! [[ "$CURRENT" =~ ^[0-9]+$ ]]; then
    exit 1
fi

if [[ "$DIR" == "next" ]]; then
    # Always step exactly one forward (creates blank if empty)
    swaymsg workspace number $(( CURRENT + 1 ))

elif [[ "$DIR" == "prev" ]]; then
    # Always step exactly one back, bounded at 1 (no 0th workspace)
    if (( CURRENT > 1 )); then
        swaymsg workspace number $(( CURRENT - 1 ))
    fi
    # If already on 1, do nothing
fi
