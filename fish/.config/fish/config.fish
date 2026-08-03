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
