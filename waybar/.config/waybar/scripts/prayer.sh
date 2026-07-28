#!/usr/bin/env bash
# Prayer times module for Waybar
# Fetches from muftyat.kz API, caches per year, shows next prayer + countdown

CACHE_DIR="$HOME/.cache"
CONFIG="$HOME/.config/waybar/prayer.json"

if [[ ! -f "$CONFIG" ]]; then
  echo '{"text":"no config","tooltip":"Create ~/.config/waybar/prayer.json"}'
  exit 0
fi

LAT=$(jq -r '.lat' "$CONFIG")
LNG=$(jq -r '.lng' "$CONFIG")
CITY=$(jq -r '.city' "$CONFIG")
YEAR=$(date +%Y)
TODAY=$(date +%Y-%m-%d)
CACHE="$CACHE_DIR/waybar-prayer-${YEAR}-${LAT}-${LNG}.json"

# Fetch if cache missing
if [[ ! -f "$CACHE" ]]; then
  curl -sf "https://api.muftyat.kz/prayer-times/${YEAR}/${LAT}/${LNG}" \
    -o "$CACHE" 2>/dev/null
  if [[ $? -ne 0 ]] || [[ ! -s "$CACHE" ]]; then
    echo '{"text":"prayer fetch","tooltip":"Failed to fetch prayer times"}'
    exit 1
  fi
fi

# Extract today's times as individual fields
read -r FAJR DHUHR ASR MAGHRIB ISHA < <(
  jq -r --arg d "$TODAY" '
        .result[] | select(.Date == $d) |
        [.fajr, .dhuhr, .asr, .maghrib, .isha] | @tsv
    ' "$CACHE" 2>/dev/null
)

if [[ -z "$FAJR" ]]; then
  echo '{"text":"no data","tooltip":"No prayer data for today"}'
  exit 1
fi

NOW_MIN=$((10#$(date +%H) * 60 + 10#$(date +%M)))

# Convert HH:MM to minutes
to_min() {
  echo $((${1:0:2} * 60 + ${1:3:2}))
}

FAJR_MIN=$(to_min "$FAJR")
DHUHR_MIN=$(to_min "$DHUHR")
ASR_MIN=$(to_min "$ASR")
MAGHRIB_MIN=$(to_min "$MAGHRIB")
ISHA_MIN=$(to_min "$ISHA")

# Prayers in order
NAMES=(Fajr Dhuhr Asr Maghrib Isha)
TIMES=("$FAJR" "$DHUHR" "$ASR" "$MAGHRIB" "$ISHA")
MINS=($FAJR_MIN $DHUHR_MIN $ASR_MIN $MAGHRIB_MIN $ISHA_MIN)

# Find next prayer
NEXT_NAME=""
NEXT_MIN=0
NEXT_TIME=""
PASSED=()

for i in 0 1 2 3 4; do
  if ((NOW_MIN < MINS[$i])); then
    if [[ -z "$NEXT_NAME" ]]; then
      NEXT_NAME="${NAMES[$i]}"
      NEXT_MIN=${MINS[$i]}
      NEXT_TIME="${TIMES[$i]}"
    fi
  else
    PASSED+=("${NAMES[$i]}")
  fi
done

# All prayers passed → next is tomorrow Fajr
if [[ -z "$NEXT_NAME" ]]; then
  NEXT_NAME="Fajr"
  NEXT_TIME="$FAJR"
  NEXT_MIN=$((FAJR_MIN + 1440))
fi

# Time remaining
DIFF_MIN=$((NEXT_MIN - NOW_MIN))
((DIFF_MIN < 0)) && DIFF_MIN=$((DIFF_MIN + 1440))
HOURS=$((DIFF_MIN / 60))
MINS_LEFT=$((DIFF_MIN % 60))
((HOURS > 0)) && REMAINING="${HOURS}h ${MINS_LEFT}m" || REMAINING="${MINS_LEFT}m"

# Waybar text
TEXT="${NEXT_NAME} ${REMAINING}"

# Tooltip: full table
# Truncate city name for tooltip
if ((${#CITY} > 10)); then
  CITY_SHORT="${CITY:0:10}..."
else
  CITY_SHORT="$CITY"
fi
TOOLTIP="<b>${CITY_SHORT} \u2014 Today</b>\n━━━━━━━━━━━━━━━━\n"

for i in 0 1 2 3 4; do
  name="${NAMES[$i]}"
  ptime="${TIMES[$i]}"
  if [[ "$name" == "$NEXT_NAME" ]]; then
    h=${ptime:0:2}
    m=${ptime:3:2}
    if ((10#$h < 12)); then ap="AM"; else ap="PM"; fi
    if ((10#$h == 0)); then h12=12; elif ((10#$h > 12)); then h12=$((10#$h - 12)); else h12=$h; fi
    TOOLTIP+="\u25b8 ${name}  ${h12}:${m} ${ap}  \u25c2\n"
  else
    mark=""
    for p in "${PASSED[@]}"; do
      [[ "$p" == "$name" ]] && mark=" \u2713" && break
    done
    # Convert to 12h
    h=${ptime:0:2}
    m=${ptime:3:2}
    if ((10#$h < 12)); then ap="AM"; else ap="PM"; fi
    if ((10#$h == 0)); then h12=12; elif ((10#$h > 12)); then h12=$((10#$h - 12)); else h12=$h; fi
    TOOLTIP+="  ${name}  ${h12}:${m} ${ap}${mark}\n"
  fi
done

TOOLTIP+="━━━━━━━━━━━━━━━━\nnext in: ${REMAINING}"

echo "{\"text\":\"${TEXT}\",\"tooltip\":\"${TOOLTIP}\",\"class\":\"${NEXT_NAME,,}\"}"
