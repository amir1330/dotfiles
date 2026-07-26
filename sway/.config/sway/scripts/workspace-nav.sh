#!/usr/bin/env bash
# Workspace navigation: next creates blank, prev stops at 1
# Usage: workspace-nav.sh next|prev

DIR="${1:-next}"

WORKSPACES=$(swaymsg -t get_workspaces | jq -r '.[].num' | sort -n)
CURRENT=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')

if [[ "$DIR" == "next" ]]; then
    # Find next workspace after current
    NEXT=""
    for ws in $WORKSPACES; do
        if (( ws > CURRENT )); then
            NEXT=$ws
            break
        fi
    done

    if [[ -n "$NEXT" ]]; then
        swaymsg workspace number "$NEXT"
    else
        # No workspace after current — create next blank
        swaymsg workspace number $(( CURRENT + 1 ))
    fi

elif [[ "$DIR" == "prev" ]]; then
    # Find workspace before current
    PREV=""
    for ws in $WORKSPACES; do
        if (( ws < CURRENT )); then
            PREV=$ws
        fi
    done

    if [[ -n "$PREV" ]]; then
        swaymsg workspace number "$PREV"
    fi
    # If no prev, do nothing (don't cycle)
fi
