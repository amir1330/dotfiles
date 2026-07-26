#!/usr/bin/env bash
# Rofi city picker for prayer times config
# Fetches all Kazakhstan cities from muftyat.kz, shows in rofi, updates config

CACHE_DIR="$HOME/.cache"
CITIES_CACHE="$CACHE_DIR/muftyat-cities.json"
CONFIG="$HOME/.config/waybar/prayer.json"
PRAYER_CACHE_DIR="$HOME/.cache"

# Fetch cities if not cached
if [[ ! -f "$CITIES_CACHE" ]]; then
    notify-send "Prayer" "Fetching city list..."
    echo '{"results":[]}' > "$CITIES_CACHE"

    PAGE=1
    while true; do
        RESP=$(curl -sf "https://api.muftyat.kz/cities/?page=${PAGE}&page_size=100" 2>/dev/null)
        [[ -z "$RESP" ]] && break

        COUNT=$(echo "$RESP" | jq '.results | length')
        [[ "$COUNT" == "0" ]] && break

        # Merge into cache
        jq -s '.[0].results + .[1].results | {results: .}' \
            "$CITIES_CACHE" <(echo "$RESP") > "$CITIES_CACHE.tmp" \
            && mv "$CITIES_CACHE.tmp" "$CITIES_CACHE"

        (( PAGE++ ))
    done

    TOTAL=$(jq '.results | length' "$CITIES_CACHE")
    notify-send "Prayer" "Loaded ${TOTAL} cities"
fi

TOTAL=$(jq -r '.results | length' "$CITIES_CACHE")

# Build rofi input: "City Name (Region) | lat | lng"
ROFI_INPUT=$(jq -r '.results[] | "\(.title) (\(.region // "—")) | \(.lat) | \(.lng)"' "$CITIES_CACHE")

# Show rofi
SELECTED=$(echo "$ROFI_INPUT" | rofi -dmenu -i \
    -theme ~/.config/rofi/config.rasi \
    -p "prayer city" \
    -mesg "Type to search  |  Enter: select  |  Esc: cancel" \
    -format "s" \
    -l 15)

[[ -z "$SELECTED" ]] && exit 0

# Parse selection
CITY_NAME=$(echo "$SELECTED" | cut -d'|' -f1 | xargs)
LAT=$(echo "$SELECTED" | cut -d'|' -f2 | xargs)
LNG=$(echo "$SELECTED" | cut -d'|' -f3 | xargs)

# Update config
jq --arg city "$CITY_NAME" --arg lat "$LAT" --arg lng "$LNG" \
    '.city = $city | .lat = $lat | .lng = $lng' \
    "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"

# Clear prayer cache to force re-fetch
rm -f "$PRAYER_CACHE_DIR"/waybar-prayer-*.json

# Refresh waybar
pkill -SIGRTMIN+10 waybar 2>/dev/null

notify-send "Prayer" "City set to: ${CITY_NAME}"
