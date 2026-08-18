# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    #date
    fastfetch
end

starship init fish | source

alias ff fastfetch
alias nv nvim

abbr mkdir "mkdir -p"

set -Ua fish_user_paths ~/.yarn/bin
fish_add_path ~/.scripts
set -gx GPG_TTY (tty)
set -gx PATH $HOME/fvm/default/bin $HOME/.pub-cache/bin $PATH
# Android Environment & Paths
set -gx ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator
set -gx CHROME_EXECUTABLE /usr/bin/chromium
