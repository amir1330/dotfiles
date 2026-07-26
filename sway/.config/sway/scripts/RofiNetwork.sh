#!/usr/bin/env bash
# Rofi-based wifi network selector using nmcli

if pgrep -x "rofi" >/dev/null; then
  pkill rofi
fi

rofi_theme="$HOME/.config/rofi/config-network.rasi"

wifi_iface=$(nmcli -t -f DEVICE,TYPE device 2>/dev/null | grep ":wifi$" | cut -d: -f1 | head -1)

if [ -z "$wifi_iface" ]; then
  notify-send "Network" "No wifi interface found"
  exit 1
fi

if [ "$1" = "--nmtui" ]; then
  kitty nmtui
  exit 0
fi

current=$(nmcli -t -f NAME,DEVICE connection show --active 2>/dev/null | grep ":${wifi_iface}$" | cut -d: -f1)

nmcli device wifi rescan 2>/dev/null
sleep 0.5

networks=$(nmcli --terse -f IN-USE,SSID,SIGNAL,SECURITY device wifi list 2>/dev/null)

menu=""
while IFS=: read -r in_use ssid signal security; do
  [ -z "$ssid" ] && continue
  [ "$ssid" = "--" ] && continue

  if [ "$security" != "--" ] && [ -n "$security" ]; then
    icon="󰌾"
  else
    icon="󰤨"
  fi

  if [ "$in_use" = "*" ]; then
    marker="  ✓"
  else
    marker=""
  fi

  menu="${menu}${icon}  ${ssid}  󰀪 ${signal}%${marker}\n"
done <<< "$networks"

if [ -z "$menu" ]; then
  notify-send "Network" "No wifi networks found"
  exit 1
fi

selected=$(printf "%b" "$menu" | rofi -dmenu -config "$rofi_theme" -mesg "󰤭  Available WiFi Networks" -selected-row 0)

if [ -z "$selected" ]; then
  exit 0
fi

network_name=$(echo "$selected" | sed 's/^[^ ]*  //; s/  󰀪 .*//')

if [ -z "$network_name" ]; then
  exit 1
fi

if echo "$selected" | grep -q "󰌾"; then
  password=$(rofi -dmenu -config "$rofi_theme" -mesg "󰌾  Password for  ${network_name}" -password -no-select)
  if [ -z "$password" ]; then
    exit 0
  fi
  result=$(nmcli device wifi connect "$network_name" ifname "$wifi_iface" password "$password" 2>&1)
else
  result=$(nmcli device wifi connect "$network_name" ifname "$wifi_iface" 2>&1)
fi

if [ $? -eq 0 ]; then
  notify-send "Network" "Connected to ${network_name}"
else
  notify-send -u critical "Network" "Failed to connect to ${network_name}"
fi
