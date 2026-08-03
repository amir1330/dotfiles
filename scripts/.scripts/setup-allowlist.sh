#!/usr/bin/env bash
# setup-allowlist -- shared curated data for setup-health / setup-config-coverage.
#
# Entries under $HOME/.config that apps manage themselves (caches, state,
# KDE/generated rc files, daemons). Entries that are neither stow-owned nor
# listed here are reported as "unmanaged" so the owner can decide whether to
# adopt them into dotfiles. Add/remove names here to tune the reports.

SETUP_APP_MANAGED_CONFIGS='
archpc_gruvbox.png
pc_gruvbox_nologo.png
unknown.png
arkrc
baloofileinformationrc
kactivitymanagerdrc
konsolerc
konsolesshconfig
kwalletrc
kwinoutputconfig.json
QtProject.conf
BambuStudio
chromium
discord
dconf
glow
gnome-boxes
JetBrains
keepassxc
Kvantum
libaccounts-glib
libvirt
mdless
menus
mimeapps.list
Moonlight Game Streaming Project
onlyoffice
pavucontrol.ini
pipewire
pulse
qdiskinfo
QuranCompanion
session
songrec
swtpm-localca.conf
swtpm-localca.options
swtpm_setup.conf
termshark
trashrc
unity3d
Upscayl
user-dirs.dirs
user-dirs.locale
uv
var
vivaldi
wireguard-gui
wireplumber
xfce4
yarn
yay
go
gtkrc
gtkrc-2.0
'
