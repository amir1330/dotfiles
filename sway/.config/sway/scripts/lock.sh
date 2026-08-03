#!/usr/bin/env bash
# lock.sh — lock the screen and force the US keyboard layout for swaylock.
# Sway's normal layout switching is restored automatically after unlock.

set -euo pipefail

# Switch to the first configured keyboard layout (us) before locking.
# layout index 0 corresponds to the first entry in xkb_layout "us,ru".
swaymsg input type:keyboard xkb_switch_layout 0 || true

# Always launch swaylock even if the layout switch command failed.
exec swaylock "$@"
