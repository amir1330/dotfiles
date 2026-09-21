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

NOW_SEC=$((10#$(date +%H) * 3600 + 10#$(date +%M) * 60 + 10#$(date +%S)))

# Convert HH:MM to seconds since midnight
to_sec() {
  echo $((10#${1:0:2} * 3600 + 10#${1:3:2} * 60))
}

FAJR_MIN=$(to_sec "$FAJR")
DHUHR_MIN=$(to_sec "$DHUHR")
ASR_MIN=$(to_sec "$ASR")
MAGHRIB_MIN=$(to_sec "$MAGHRIB")
ISHA_MIN=$(to_sec "$ISHA")

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
  if ((NOW_SEC < MINS[$i])); then
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
  NEXT_MIN=$((FAJR_MIN + 86400))
fi

# Time remaining (second precision, floored to minutes so it never over-estimates)
DIFF_SEC=$((NEXT_MIN - NOW_SEC))
((DIFF_SEC < 0)) && DIFF_SEC=$((DIFF_SEC + 86400))
DIFF_MIN=$((DIFF_SEC / 60))
HOURS=$((DIFF_MIN / 60))
MINS_LEFT=$((DIFF_MIN % 60))
if ((HOURS > 0)); then
  REMAINING="${HOURS}h ${MINS_LEFT}m"
else
  REMAINING="${MINS_LEFT}m"
fi

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
  # Convert to 12h
  h=${ptime:0:2}
  m=${ptime:3:2}
  if ((10#$h < 12)); then ap="AM"; else ap="PM"; fi
  if ((10#$h == 0)); then h12=12; elif ((10#$h > 12)); then h12=$((10#$h - 12)); else h12=$h; fi
  line="  ${name}  ${h12}:${m} ${ap}"
  if [[ "$name" == "$NEXT_NAME" ]]; then
    TOOLTIP+="<span color='#d65d0e'>${line}</span>\n"
  elif [[ " ${PASSED[*]} " == *" ${name} "* ]]; then
    TOOLTIP+="<span color='#98971a'>${line} \u2713</span>\n"
  else
    TOOLTIP+="${line}\n"
  fi
done

TOOLTIP+="━━━━━━━━━━━━━━━━\nnext in: ${REMAINING}"

echo "{\"text\":\"${TEXT}\",\"tooltip\":\"${TOOLTIP}\",\"class\":\"${NEXT_NAME,,}\"}"
