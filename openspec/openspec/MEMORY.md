# Session memory (newest on top)

Read this at session start. Append an entry at session end when something
worth remembering happened. Keep entries short and factual.

## 2026-10-10 — perf/power/RAM audit (commands given, not yet applied)

- Box: Lenovo IdeaPad Slim 5 14IAH8, i5-12450H, 15Gi RAM, NVMe, Intel iGPU.
  Baseline sane: TLP active, EPP=power on battery, wifi ps on, scheduler
  `none`, 13G RAM free. Biggest hog is opencode itself (~930M RSS, 916M db).
- Offered (user: no sudo for agent, do what's best): zram 4G prio 100 +
  swappiness 10; disable NM-wait-online (~4s boot); thermald; GRUB
  `mem_sleep_default=deep` (s2idle now); TLP BAT EPP power→balance_power.
- Status 2026-10-10 17:45: user ran everything. Verified: zram0 active
  (3.8G prio 100), thermald+tlp active, EPP=balance_power, grub.cfg
  regenerated. Pending: `sudo sysctl --system` (swappiness still 60 until
  reboot) + reboot for deep sleep.
- Left alone deliberately: AC perf settings, bluetooth (paired earbuds),
  wayvnc 24/7 (cheap, may be used), scheduler, opencode.db vacuum (optional).

## 2026-10-10 — commit batch + README ascii (commit: see log)

- Committed+pushed today's batch. Commit 1 (mine): gtk4 switchable
  themes, windowless nautilus preload, push-based backlight, 2% steps +
  no-repeat, agents/memory system, README rewrite. Commit 2 (user's own
  tweaks found in tree): wallpaper line + --release on screenshot/ocr.
- README: all emoji/non-ASCII removed (strict ASCII); stale Thunar refs
  replaced with Nautilus (Thunar not installed, dropped from stow list);
  added backlight.sh row, agent-memory note, 2% step notes.

## 2026-10-10 — backlight display lag → push-based custom module

- Polling (even 1s) still lagged a full press behind. Replaced built-in
  `backlight` module with `custom/backlight` (signal 8, interval 1 fallback).
- New `waybar/scripts/backlight.sh [up|down]`: steps 2% via brightnessctl,
  prints `bl NN%`, then `pkill -RTMIN+8 waybar` for instant refresh.
  Keys (XF86 + $mod+Ctrl+minus/equal) and scroll both call it.
- Gotcha: `brightnessctl -m` field order is dev,class,raw,percent,max
  (percent is $4, not $3/$4) — first version printed `bl 400%`.
- Style selector renamed `#backlight` → `#custom-backlight`.
- Verified: 58→60→58 exact steps, waybar survives RTMIN+8, sway reload ok.
  User confirmed: "PERFECT NOW".

## 2026-10-10 — waybar scroll steps + brightness jitter (uncommitted)

- Scroll steps 5%→2%: waybar `pulseaudio` + `backlight` on-scroll, and sway
  keybinds (vol ±, brightness ± incl. $mod+Ctrl+minus/equal).
- Jitter causes: key repeat fired extra steps (50→70 on 3 presses);
  waybar backlight polled every 2s (default) showing stale mid values.
- Fix: `--no-repeat` on mute/vol/mic/brightness bindsyms (verified flag
  live first; sway 1.12), backlight `interval: 1`. pulseaudio module is
  event-driven, needed no change.
- Note: intel_backlight max=400 so % math is exact; if one press still
  jumps ~2 steps, the Lenovo EC handles Fn keys in hardware too — then
  drop the sway brightness bindings and let EC do it (waybar still shows it).
- Verified: waybar JSON ok, sway reload ok, waybar restarted, 2% step
  tested (down+up, net zero).

## 2026-10-10 — nautilus backdrop color shift (uncommitted fix)

- Symptom: Nautilus visibly shifted colors when losing focus.
- Cause: `themes/dark.css` defined no `*_backdrop_color` variants, so
  libadwaita fell back to stock Adwaita-dark for unfocused state.
  (light.css already had them.)
- Fix (uncommitted): pinned all backdrop colors in `themes/dark.css` to
  their focused values (headerbar/sidebar #1d2021, view/2nd-sidebar
  #282828, popover #3c3836, dialog #32302f, shades rgba black) — no
  unfocus dimming at all. Re-warmed Nautilus windowless; live gtk.css
  updated.
- Also fixed stale "dark variant preserved in git history" comment in
  light.css (dark now lives in `themes/dark.css`).

## 2026-10-10 — nautilus stuck light + preload flash (uncommitted fix)

- Symptom: Nautilus stayed light on dark theme; user hated the preload
  open-then-close flash.
- Causes: `gtk-4.0/gtk.css` (libadwaita named-color override — the actual
  Nautilus "Gruvbox overwrite") existed only as Gruvbox-Light; the
  wallpaper-picker never swapped it, and dark variant lived only in git
  history (`ea24ef7`). Preload opened a real window then moved it to
  scratchpad = visible flash.
- Fix (uncommitted): split into `gtk4/.config/gtk-4.0/themes/{dark,light}.css`
  (dark restored from `ea24ef7`, light = current file), `gtk.css` is now the
  live copy; picker copies `themes/$target.css` on switch like waybar/swaync.
  Preload rewritten to `nautilus --gapplication-service` (D-Bus service mode:
  warms app/tracker/caches, zero windows, no flash ever).
- Verified live: dark css live (`window_bg_color #282828`), Nautilus running
  windowless (PID, 0 windows in sway tree). Next Win+E opens dark + fast.
- Correction to earlier entry: Nautilus DOES wear Gruvbox via gtk.css
  named colors (not just Adwaita); adw-gtk3 not needed. Earlier fix's
  restart logic kept, now with windowless re-warm.

## 2026-10-10 — agent memory system created

- No persistent memory existed: every session started blank (user asked
  "do you remember what we did to file manager" — had to reconstruct from
  git log).
- Created `~/AGENTS.md` (stowed from `dotfiles/agents/`) instructing agents
  to read/update this file. Added `agents` to the stow package list in
  `dotfiles/README.md`.
- Convention: openspec `changes/` for plans, this file for outcomes/decisions.

## 2026-10-06 — Nautilus preload, portal env fix (`2a3adec`)

- `sway/config`: import `GTK_USE_PORTAL` (+ `XDG_SESSION_TYPE`, `GTK_THEME`)
  into systemd/dbus env, start `xdg-desktop-portal-gnome`, added
  `nautilus-preload.sh` (open Nautilus at login, hide to scratchpad —
  warm Win+E ~0.2s vs ~2.2s cold). Dropped login-popup float rules.
- `portals.conf` / `sway-portals.conf` tweaked. README keybinds/stack
  corrected (still lists `$mod+e = Thunar` — stale, live config is Nautilus).

## 2026-09-21 — pickfm custom file manager (`ea24ef7`)

- New `scripts/.scripts/pickfm` (Python/GTK3, `Gtk.FileChooserWidget` in a
  1100x700 window): folder nav, double-click open via `Gio.AppInfo`,
  `Hidden` toggle, `New folder`, `Terminal` (`kitty --directory`), title =
  current folder, optional start-dir arg. On PATH via `~/.scripts`.
- New `pickfm/.local/share/applications/pickfm.desktop`
  (`Exec=pickfm %U`, `StartupWMClass=pickfm`).
- `GTK_USE_PORTAL=1` exported in bash/fish; xdg-portal gtk/wlr backends +
  Gruvbox GTK theming added so picker and pickfm match.
- `$mod+e` was Thunar at the time; later switched to Nautilus (see 2026-10-06).
  pickfm is the alt manager, not the default binding.
