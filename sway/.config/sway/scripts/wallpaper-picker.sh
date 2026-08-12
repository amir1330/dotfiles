#!/usr/bin/env bash
# Rofi-based wallpaper picker with thumbnail previews + gruvbox light/dark theme switching

set -euo pipefail

WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
THUMB_SIZE="300x200"
THEME="$HOME/.config/rofi/config-wallpaper.rasi"
STATE_FILE="$HOME/.cache/current-theme"
SWAY_CONFIG="$HOME/.config/sway/config"

mkdir -p "$CACHE_DIR"

# --- Build rofi menu (brightness read from cached thumbnails = fast) ---
tempfile=$(mktemp)
trap 'rm -f "$tempfile"' EXIT

find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    -print0 2>/dev/null | sort -zV | while IFS= read -r -d '' img; do

    name=$(basename "$img")
    base="${name%.*}"
    thumb="$CACHE_DIR/$name"

    # Generate thumbnail only if missing or source changed
    if [[ ! -f "$thumb" ]] || [[ "$img" -nt "$thumb" ]]; then
        magick "$img" -resize "${THUMB_SIZE}^" -gravity center -extent "$THUMB_SIZE" "$thumb" 2>/dev/null || \
        convert "$img" -resize "${THUMB_SIZE}^" -gravity center -extent "$THUMB_SIZE" "$thumb" 2>/dev/null || true
    fi

    # Brightness from the small cached thumbnail (fast)
    brightness=$(magick "$thumb" -colorspace Gray -format "%[fx:mean]" info: 2>/dev/null || echo "0")

    if [[ -n "$brightness" ]] && (( $(echo "$brightness > 0.5" | bc -l) )); then
        kind="[L]"
    else
        kind="[D]"
    fi

    printf '%s  %s\0icon\x1f%s\n' "$base" "$kind" "$thumb"
done > "$tempfile"

if [[ ! -s "$tempfile" ]]; then
    notify-send "Wallpapers" "No images found in ${WALLPAPER_DIR}"
    exit 1
fi

selected=$(rofi -dmenu -show-icons -i \
    -theme "$THEME" \
    -mesg "arrows: navigate  |  Enter: apply  |  Esc: cancel" \
    < "$tempfile") || true

[[ -z "${selected:-}" ]] && exit 0

base="${selected%%  *}"

img=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    -name "${base}.*" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    -print -quit 2>/dev/null)

[[ -z "$img" || ! -f "$img" ]] && exit 1

# --- Apply wallpaper (live + persist in sway config for reloads) ---
swaymsg output "*" bg "$img" fill
sed -i "s|^output \* bg .*|output * bg $img fill|" "$SWAY_CONFIG"

# --- Theme switching (gruvbox light/dark) ---
if [[ "$selected" == *"[L]"* ]]; then
    target="light"
else
    target="dark"
fi

current=$(cat "$STATE_FILE" 2>/dev/null || true)
[[ -z "$current" ]] && current="dark"

if [[ "$target" != "$current" ]]; then
    # sway borders
    cp "$HOME/.config/sway/themes/$target" "$HOME/.config/sway/theme-colors"

    # waybar
    cp "$HOME/.config/waybar/themes/$target.css" "$HOME/.config/waybar/colors.css"

    # rofi (read at launch, no reload needed)
    cp "$HOME/.config/rofi/themes-live/$target.rasi" "$HOME/.config/rofi/colors.rasi"

    # wlogout (read at launch, no reload needed)
    cp "$HOME/.config/wlogout/themes/$target.css" "$HOME/.config/wlogout/style.css"

    # swaync (restart to apply new CSS)
    cp "$HOME/.config/swaync/themes/$target.css" "$HOME/.config/swaync/style.css"
    killall swaync 2>/dev/null || true
    swaync &

    # kitty (file + live reload of open windows)
    cp "$HOME/.config/kitty/themes/gruvbox-$target.conf" "$HOME/.config/kitty/current-theme.conf"
    kitty @ --to unix:/tmp/kitty set-colors --all "$HOME/.config/kitty/current-theme.conf" 2>/dev/null || true

    # GTK
    if [[ "$target" == "light" ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Light' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
        sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Gruvbox-Light/' "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark' 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
        sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Gruvbox-Dark/' "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
    fi

    # btop
    sed -i "s/^color_theme = .*/color_theme = \"gruvbox_$target\"/" "$HOME/.config/btop/btop.conf"
    pkill -USR2 btop 2>/dev/null || true

    # reload sway (applies new border colors + re-reads wallpaper line we just sed'ed)
    # sway does NOT restart waybar on reload if the bar command hasn't changed,
    # so kill it first — sway will re-spawn it from the config on reload
    killall waybar 2>/dev/null || true
    swaymsg reload

    # ensure waybar is running (sway should start it, but just in case)
    sleep 0.5
    pgrep -x waybar >/dev/null || waybar &

    echo "$target" > "$STATE_FILE"
    notify-send "Theme" "Gruvbox $target — restart browsers to apply" -t 3000
fi

notify-send "Wallpaper" "$(basename "$img")" -t 2000
