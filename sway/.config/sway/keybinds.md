> AI INSTRUCTION: When sway/config is updated, regenerate this file.
> Parse bindsym lines from ~/.config/sway/config and group by section comment headers (## or # SectionName:).
> $mod = Super key. $left/h/j/k/l = vim direction keys.
> For mode blocks, prefix binds with the mode name (e.g. "Screenshot > s | screen").
> Format each entry as: `KeyCombo | Description`
> Separate groups with blank lines. Header format: ## Group Name
> Keep descriptions short. Omit lines that are not user-facing (Return, Escape in modes).

## General

$mod+t | kitty
$mod+q | kill focused window
$mod+d | rofi drun
$mod+Shift+d | rofi run
$mod+b | qutebrowser
$mod+e | thunar
$mod+z | wlogout
$mod+v | cliphist (paste history)
$mod+Shift+w | wallpaper picker
$mod+Ctrl+Shift+n | wlsunset night mode on
$mod+Ctrl+Alt+n | wlsunset night mode off
$mod+Shift+c | reload sway config
$mod+Shift+q | exit sway (with confirmation)
$mod+space | switch keyboard layout (us/ru)
$mod+/ | show this keybind cheatsheet

## Navigation

$mod+h/j/k/l | focus left/down/up/right
$mod+arrows | focus direction
$mod+Shift+h/j/k/l | move window left/down/up/right
$mod+Shift+arrows | move window direction

## Workspaces

$mod+1-0 | switch to workspace 1-10
$mod+Shift+1-0 | move window to workspace 1-10
$mod+Ctrl+l | next workspace
$mod+Ctrl+h | previous workspace

## Layout

$mod+s | stacking layout
$mod+w | tabbed layout
$mod+x | toggle split layout
$mod+f | fullscreen toggle
$mod+Shift+f | floating toggle
$mod+a | focus parent

## Scratchpad

$mod+minus | show/hide scratchpad
$mod+Shift+minus | move window to scratchpad

## Resize

$mod+r | enter resize mode
(h/j/k/l or arrows inside mode) | resize window

## Screenshot

Print | fullscreen
$mod+Shift+s | active window

## Screen recording

$mod+Shift+r | toggle recording (desktop audio)
$mod+Ctrl+r | toggle recording (mic + desktop audio)

## Media

XF86AudioMute | mute volume
XF86AudioLowerVolume | volume down
XF86AudioRaiseVolume | volume up
XF86AudioMicMute | mute mic
XF86AudioPlay | play/pause
XF86AudioNext | next track
XF86AudioPrev | previous track
XF86MonBrightnessDown | brightness down
XF86MonBrightnessUp | brightness up
$mod+Ctrl+minus | brightness down
$mod+Ctrl+equal | brightness up
