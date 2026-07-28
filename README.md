# dotfiles

Sway + Gruvbox dotfiles managed with GNU Stow.

## Stack

| Component | Choice |
|---|---|
| WM | Sway |
| Shell | Bash, Fish |
| Terminal | Kitty |
| Launcher | Rofi |
| Bar | Waybar |
| Notifications | SwayNC |
| Lockscreen | Swaylock |
| Logout | Wlogout |
| Editor | Neovim (LazyVim) |
| Prompt | Starship |
| Color gen | Wallust |
| File manager | Thunar |

## Theme

Gruvbox throughout. Dark/light mode switching via wallpaper picker that propagates across sway, waybar, rofi, wlogout, swaync, kitty, GTK, and btop.

## Setup

```sh
git clone https://github.com/amir1330/dotfiles ~/dotfiles
cd ~/dotfiles
stow -t ~ */
```

## Scripts

- `wallpaper-picker.sh` -- rofi wallpaper picker with full theme switch
- `workspace-nav.sh` -- smart workspace navigation
- `prayer.sh` -- Islamic prayer times in waybar
- `RofiNetwork.sh` -- network manager frontend
- `screenshot.sh` -- screen/window/region/freeze screenshots
- `screenshot` -- region screenshot via grim+slurp

## Keybinds

`$mod` = Super.

### General

| Bind | Action |
|---|---|
| `$mod+t` | kitty |
| `$mod+q` | kill focused |
| `$mod+d` | rofi drun |
| `$mod+Shift+d` | rofi run |
| `$mod+b` | qutebrowser |
| `$mod+e` | thunar |
| `$mod+z` | wlogout |
| `$mod+v` | cliphist |
| `$mod+Shift+w` | wallpaper picker |
| `$mod+Shift+s` | freeze region screenshot |
| `$mod+f` | fullscreen |
| `$mod+Shift+f` | toggle float |
| `$mod+a` | focus parent |
| `$mod+space` | switch keyboard layout |
| `$mod+minus` / `$mod+Shift+minus` | scratchpad show / move |
| `$mod+Ctrl+Shift+n` | wlsunset on |
| `$mod+Ctrl+Alt+n` | wlsunset off |
| `$mod+Shift+c` | reload config |
| `$mod+/` | show keybind cheatsheet |
| `$mod+Shift+q` | exit sway |

### Navigation

| Bind | Action |
|---|---|
| `$mod+h/j/k/l` | focus left/down/up/right |
| `$mod+arrows` | focus direction |
| `$mod+Shift+h/j/k/l` | move window |
| `$mod+Shift+arrows` | move window |
| `$mod+Ctrl+h/l` | prev/next workspace |

### Workspaces

| Bind | Action |
|---|---|
| `$mod+1-9,0` | switch to workspace 1-10 |
| `$mod+Shift+1-9,0` | move window to workspace 1-10 |

### Screenshot mode (Press `Print`)

| Key | Action |
|---|---|
| `s` | full screen |
| `w` | active window |
| `r` | region |
| `f` | freeze then region |

### Media

| Key | Action |
|---|---|
| XF86Audio (Mute/Lower/Raise) | volume |
| XF86AudioMicMute | mic toggle |
| XF86Audio (Play/Next/Prev) | playerctl |
| XF86MonBrightness (Down/Up) | brightness |
| `$mod+Ctrl+minus/equal` | brightness |

### Touchpad

3-finger swipe left/right for workspace navigation.
