function fish_prompt --description 'Directory above a clean command line'
    set_color ffb0b8
    printf '%s\n' "$PWD"
    set_color normal
end
