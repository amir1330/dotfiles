<h1 align="center">🌲 dotfiles</h1>

<p align="center">
  <b>A Gruvbox-flavoured Sway desktop on Arch, managed with GNU Stow.</b>
</p>

<p align="center">
  <a href="https://www.gnu.org/software/stow/"><img src="https://img.shields.io/badge/managed%20with-Stow-8ec07c?logo=gnu&logoColor=ebdbb2&style=for-the-badge&color=282828&labelColor=282828"></a>
  <a href="https://swaywm.org/"><img src="https://img.shields.io/badge/WM-Sway-458588?style=for-the-badge&color=282828&labelColor=282828"></a>
  <a href="https://github.com/morhetz/gruvbox"><img src="https://img.shields.io/badge/theme-Gruvbox-d79921?style=for-the-badge&color=282828&labelColor=282828"></a>
  <a href="https://archlinux.org/"><img src="https://img.shields.io/badge/OS-Arch-1793d1?style=for-the-badge&color=282828&labelColor=282828&logo=arch-linux&logoColor=1793d1"></a>
</p>

<p align="center">
  <img src="screenshots/desktop.png" alt="Desktop screenshot" width="85%">
</p>

> 💡 <b>Screenshots are placeholders.</b> See the <a href="#screenshots">Screenshots</a> section for capture instructions.

## ✨ Features

| Feature | Description |
|---|---|
| **Tiling WM** | Sway with smart gaps, pixel borders, and touchpad gestures. |
| **Theme engine** | Gruvbox everywhere. Switch dark/light from a wallpaper picker and the theme propagates across Sway, Waybar, Rofi, Wlogout, SwayNC, Kitty, GTK, and btop. |
| **Keyboard-driven** | Vim-style navigation, workspace switching, and a full screenshot/media keybind set. |
| **Helper scripts** | Wallpaper picker, workspace navigator, network frontend, screenshot tools, prayer times, and more. |
| **Self-auditing** | `setup-health`, `setup-inventory`, and `setup-config-coverage` keep the install honest. |
| **Lock-safe** | `swaylock` is wrapped so it always opens with the `us` keyboard layout, even if you locked while typing in `ru`. |

## 🖼️ Screenshots

<p align="center">
  <img src="screenshots/rofi.png" alt="Rofi launcher" width="45%">
  &nbsp;
  <img src="screenshots/waybar.png" alt="Waybar" width="45%">
</p>

<p align="center">
  <img src="screenshots/kitty.png" alt="Kitty terminal" width="45%">
  &nbsp;
  <img src="screenshots/wlogout.png" alt="Wlogout menu" width="45%">
</p>

<details>
<summary>📸 How to capture these screenshots</summary>

Run the helper script on your live Sway session:

```sh
~/.config/sway/scripts/capture-readme-screenshots.sh
```

It will write:
- `screenshots/desktop.png` — clean desktop
- `screenshots/rofi.png` — launcher
- `screenshots/waybar.png` — status bar
- `screenshots/kitty.png` — terminal with a fetch command
- `screenshots/wlogout.png` — logout menu

Optimise the images (`oxipng`, `pngquant`, or ImageMagick) before committing.

</details>

## 🧱 Stack

| Component | Choice | Dotfiles package |
|---|---|---|
| WM | [Sway](https://swaywm.org/) | [`sway`](sway/.config/sway) |
| Lock screen | [Swaylock](https://github.com/swaywm/swaylock) | [`swaylock`](swaylock/.config/swaylock) |
| Logout menu | [Wlogout](https://github.com/ArtsyMacaw/wlogout) | [`wlogout`](wlogout/.config/wlogout) |
| Shell | Bash + Fish | [`bash`](bash), [`fish`](fish/.config/fish) |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) | [`kitty`](kitty/.config/kitty) |
| Launcher | [Rofi](https://github.com/lbonn/rofi) (Wayland fork) | [`rofi`](rofi/.config/rofi) |
| Bar | [Waybar](https://github.com/Alexays/Waybar) | [`waybar`](waybar/.config/waybar) |
| Notifications | [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | [`swaync`](swaync/.config/swaync) |
| Editor | [Neovim](https://neovim.io/) (LazyVim) | [`nvim`](nvim/.config/nvim) |
| Prompt | [Starship](https://starship.rs/) | [`starship`](starship) |
| File manager | [Thunar](https://docs.xfce.org/xfce/thunar/start) | [`Thunar`](Thunar/.config/Thunar) |
| Gestures | [libinput-gestures](https://github.com/bulletmark/libinput-gestures) | [`libinput`](libinput/.config/libinput-gestures) |
| Music visualiser | [cava](https://github.com/karlstav/cava) | [`cava`](cava/.config/cava) |

## 🚀 Installation

```sh
git clone https://github.com/amir1330/dotfiles ~/dotfiles
cd ~/dotfiles
stow -t ~ */
```

> You will need [GNU Stow](https://www.gnu.org/software/stow/) installed. After stowing, log out and back into Sway.

## ⌨️ Keybinds

`$mod` = <kbd>Super</kbd>/<kbd>Win</kbd>.

### General

| Bind | Action |
|---|---|
| `$mod+Return` | open terminal (Kitty) |
| `$mod+q` | kill focused window |
| `$mod+d` | Rofi drun launcher |
| `$mod+Shift+d` | Rofi run dialog |
| `$mod+b` | Qutebrowser |
| `$mod+e` | Thunar file manager |
| `$mod+z` | Wlogout menu |
| `$mod+v` | cliphist selector |
| `$mod+Shift+w` | wallpaper picker (with theme switch) |
| `$mod+f` | toggle fullscreen |
| `$mod+Shift+f` | toggle floating |
| `$mod+a` | focus parent container |
| `$mod+space` | switch keyboard layout (`us` ↔ `ru`) |
| `$mod+minus` / `$mod+Shift+minus` | scratchpad show / move |
| `$mod+Shift+c` | reload Sway config |
| `$mod+/` | show keybind cheatsheet |
| `$mod+Shift+q` | exit Sway |

### Navigation

| Bind | Action |
|---|---|
| `$mod+h/j/k/l` | focus left/down/up/right |
| `$mod+arrows` | focus direction |
| `$mod+Shift+h/j/k/l` | move window |
| `$mod+Shift+arrows` | move window |
| `$mod+Ctrl+h/l` | previous/next workspace |

### Workspaces

| Bind | Action |
|---|---|
| `$mod+1` … `$mod+0` | switch to workspace 1–10 |
| `$mod+Shift+1` … `$mod+Shift+0` | move window to workspace 1–10 |

### Screenshots

| Key | Action |
|---|---|
| `Print` | full screen |
| `$mod+Shift+s` | active window |

The annotation window temporarily switches the keyboard layout to `us` so swappy's English shortcuts (`a`, `t`, `q`, etc.) work even if you were typing in `ru`.

### Media & brightness

| Key | Action |
|---|---|
| `XF86AudioMute` / `XF86AudioLowerVolume` / `XF86AudioRaiseVolume` | volume control |
| `XF86AudioMicMute` | mic toggle |
| `XF86AudioPlay` / `XF86AudioNext` / `XF86AudioPrev` | media control |
| `XF86MonBrightnessDown` / `XF86MonBrightnessUp` | brightness |
| `$mod+Ctrl+minus` / `$mod+Ctrl+equal` | brightness (alternate) |

### Touchpad

- 3-finger swipe left/right → next/previous workspace.

## 🔧 Maintenance

Helper scripts live in [`scripts/.scripts`](scripts/.scripts) and are exposed on `PATH` via `~/.scripts`.

| Script | Purpose |
|---|---|
| `setup-health` | Audits broken symlinks, empty stow packages, uncommitted dotfiles changes, unmanaged `~/.config` entries, secrets in tracked files, and required tools. Prints `PASS`/`WARN`/`FAIL` per check and exits non-zero on any `FAIL`. |
| `setup-inventory` | Writes `~/setup-inventory.md` (override with `SETUP_INVENTORY_OUT`): OS/desktop, stow packages, toolchains, opencode providers, projects. |
| `setup-config-coverage` | Writes `~/.local/share/setup-config-coverage.md` classifying each `~/.config` entry as stow-managed, app-managed, or unmanaged (with adoption hints). |

The allowlist of app-managed config entries is curated in [`scripts/.scripts/setup-allowlist.sh`](scripts/.scripts/setup-allowlist.sh). Run `setup-health` after changing dotfiles to confirm the setup stays healthy.

## 📜 Scripts

| Script | What it does |
|---|---|
| [`sway/scripts/lock.sh`](sway/.config/sway/scripts/lock.sh) | Switches keyboard layout to `us`, then runs `swaylock`. Called from the Wlogout lock and suspend buttons. |
| [`sway/scripts/wallpaper-picker.sh`](sway/.config/sway/scripts/wallpaper-picker.sh) | Rofi wallpaper picker with full theme switch across the desktop. |
| [`sway/scripts/workspace-nav.sh`](sway/.config/sway/scripts/workspace-nav.sh) | Smart workspace navigation. |
| [`sway/scripts/RofiNetwork.sh`](sway/.config/sway/scripts/RofiNetwork.sh) | NetworkManager frontend in Rofi. |
| [`sway/scripts/screenrecord.sh`](sway/.config/sway/scripts/screenrecord.sh) | Screen recording (desktop audio). |
| [`sway/scripts/screenrecord-mic.sh`](sway/.config/sway/scripts/screenrecord-mic.sh) | Screen recording with mic + desktop audio. |
| [`sway/scripts/screenshot.sh`](sway/.config/sway/screenshot.sh) | Screen/window/region/freeze screenshots. |

## 🎨 Theme

Gruvbox throughout. Dark/light mode switching is handled by the wallpaper picker and propagated across Sway, Waybar, Rofi, Wlogout, SwayNC, Kitty, GTK, and btop.

## 🔐 Lock screen layout fix

Because Sway uses both `us` and `ru` keyboard layouts, locking with `swaylock` while the active layout is `ru` makes it impossible to type an English password. The [`lock.sh`](sway/.config/sway/scripts/lock.sh) wrapper switches the keyboard layout to `us` before launching `swaylock`, so the lock screen is always usable. The Wlogout `lock` and `suspend` actions both use this wrapper.

---

<p align="center">
  <sub>Made with ❤️ and too much Gruvbox.</sub>
</p>
