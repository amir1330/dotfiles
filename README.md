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

## Maintenance

Helper scripts live in `scripts/.scripts` and are exposed on `PATH` via `~/.scripts`.

- `setup-health` -- audits the setup: broken symlinks, empty stow packages, uncommitted
  dotfiles changes, unmanaged `~/.config` entries, secrets in tracked files, and required
  tools. Prints `PASS`/`WARN`/`FAIL` per check and exits non-zero on any `FAIL`.
- `setup-inventory` -- writes `~/setup-inventory.md` (override with `SETUP_INVENTORY_OUT`):
  OS/desktop, stow packages, toolchains, opencode providers, projects.
- `setup-config-coverage` -- writes `~/.local/share/setup-config-coverage.md` classifying each
  `~/.config` entry as stow-managed, app-managed, or unmanaged (with adoption hints).

The allowlist of app-managed config entries is curated in
`scripts/.scripts/setup-allowlist.sh`; add/remove names there to tune the reports.

Run `setup-health` after changing dotfiles to confirm the setup stays healthy.

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
| `$mod+Shift+s` | select region screenshot |
| `$mod+Ctrl+s` | active window screenshot |
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

### Screenshot

| Key | Action |
|---|---|
| `Print` | full screen |
| `$mod+Shift+s` | region |
| `$mod+Ctrl+s` | active window |

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
