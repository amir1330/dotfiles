# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    #date
end

starship init fish | source

set -Ua fish_user_paths ~/.yarn/bin
set -gx GPG_TTY (tty)
