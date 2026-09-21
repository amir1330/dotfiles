#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/bin/env"

# Force browsers to use the portal file picker (Gruvbox-themed, square)
export GTK_USE_PORTAL=1
# helper scripts (screenshot, setup-health, ...)
export PATH="$HOME/.scripts:$PATH"
