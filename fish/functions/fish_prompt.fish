function fish_prompt --description 'Directory, active environment, and a plain input marker'
    set_color ffb0b8
    printf '%s' "$PWD"
    if set -q VIRTUAL_ENV; and test -n "$VIRTUAL_ENV"
        set -l environment_name (path basename -- "$VIRTUAL_ENV")
        if contains -- "$environment_name" .venv venv
            set environment_name (path basename -- (path dirname -- "$VIRTUAL_ENV"))/"$environment_name"
        end
        set_color c9a6cc
        printf ' [venv: %s]' "$environment_name"
    else if set -q CONDA_DEFAULT_ENV; and test -n "$CONDA_DEFAULT_ENV"
        set_color c9a6cc
        printf ' [conda: %s]' "$CONDA_DEFAULT_ENV"
    end
    printf '\n'
    set_color a2c8c8
    printf '> '
    set_color normal
end
