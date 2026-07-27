# dotfiles

Sway + Gruvbox dotfiles managed with GNU Stow.

## Stack

| Component | Choice |
|---|---|
| WM | Sway |
| Shell | Bash, Fish |
| Terminal | Kitty, Ghostty |
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

Gruvbox throughout. Dark/light mod switching via wallpaper picker script that propagates across sway, waybar, rofi, wlogout, swaync, kitty, GTK, and btop.

## Setup

```sh
git clone https://github.com/amir-kazakh/dotfiles ~/dotfiles
cd ~/dotfiles
stow -t ~ */
```

## Scripts

- `screenshot` -- region screenshot via grim+slurp
- `wallpaper-picker.sh` -- rofi wallpaper picker with full theme switch
- `workspace-nav.sh` -- smart workspace navigation
- `prayer.sh` -- Islamic prayer times in waybar
- `RofiNetwork.sh` -- network manager frontend

## Keybinds

- `$mod` -- Super
- `$mod+Return` -- kitty
- `$mod+d` -- rofi
- `$mod+Shift+q` -- kill focused
- `$mod+[1-9]` -- switch workspace
- `$mod+Shift+[1-9]` -- move to workspace
- `$mod+Shift+e` -- logout menu
- `Print` -- screenshot region
- `3-finger swipe` -- workspace navigation
