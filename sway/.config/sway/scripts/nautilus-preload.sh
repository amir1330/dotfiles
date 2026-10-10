#!/bin/sh
# Warm Nautilus with no window at all (no open/close flash).
# --gapplication-service registers the app on D-Bus (runs startup(),
# connects Tracker, warms caches) without creating any window, so the
# first Win+E only pays for window creation.
set -u

pgrep -x nautilus >/dev/null 2>&1 && exit 0

/usr/bin/nautilus --gapplication-service >/dev/null 2>&1 &
