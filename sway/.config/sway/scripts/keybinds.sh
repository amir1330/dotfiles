#!/bin/sh
HTML=/tmp/keybinds.html

cat > "$HTML" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Keybinds</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  background: #1d2021;
  color: #ebdbb2;
  font-family: 'JetBrains Mono', 'Fira Code', monospace;
  font-size: 12px;
  padding: 24px;
  columns: 3 320px;
  column-gap: 20px;
}
h2 {
  color: #fabd2f;
  font-size: 13px;
  font-weight: bold;
  margin-bottom: 6px;
  padding-bottom: 4px;
  border-bottom: 1px solid #504945;
  break-inside: avoid;
}
.item {
  display: flex;
  gap: 8px;
  padding: 2px 0;
  break-inside: avoid;
}
.key {
  color: #b8bb26;
  white-space: nowrap;
  min-width: 160px;
}
.desc {
  color: #bdae93;
}
.br { margin-bottom: 10px; break-inside: avoid; }
</style>
</head>
<body>
EOF

sed '/^>/d' ~/.config/sway/keybinds.md | while IFS= read -r line; do
  case "$line" in
    "##"*)
      section=$(echo "$line" | sed 's/^## //')
      echo "<h2>$section</h2>" >> "$HTML"
      ;;
    *\|*)
      key=$(echo "$line" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
      desc=$(echo "$line" | cut -d'|' -f2- | sed 's/^ *//;s/ *$//')
      echo "<div class=item><span class=key>$key</span><span class=desc>$desc</span></div>" >> "$HTML"
      ;;
    "")
      echo "<div class=br></div>" >> "$HTML"
      ;;
  esac
done

echo "</body></html>" >> "$HTML"

qutebrowser --target window "$HTML" &
sleep 0.3
swaymsg floating enable, move position center, resize set 900 750
