# GlossyGlass: quiet startup and readable, plain-text interaction.
if status is-interactive
    set -g fish_greeting
    set -g fish_color_normal c0cfea
    set -g fish_color_command ffb0b8 --bold
    set -g fish_color_keyword ecb0bb
    set -g fish_color_quote bedbc0
    set -g fish_color_redirection c9a6cc
    set -g fish_color_end dec49e --bold
    set -g fish_color_error ff7f91 --bold
    set -g fish_color_param c0cfea
    set -g fish_color_comment 94868e
    set -g fish_color_operator dec49e
    set -g fish_color_escape a2c8c8
    set -g fish_color_autosuggestion 94868e
    set -g fish_color_option a2c8c8
    set -g fish_color_cwd ffb0b8
    set -g fish_color_cwd_root ff7f91
    set -g fish_color_cancel ff7f91 --bold
    set -g fish_color_history_current c9a6cc
    set -g fish_color_valid_path --underline
    set -g fish_color_search_match --background=59343e
    set -g fish_color_selection --background=59343e
    set -g fish_pager_color_prefix ffb0b8 --bold
    set -g fish_pager_color_completion eadfe2
    set -g fish_pager_color_description bfaeb4
    set -g fish_pager_color_progress a2c8c8
    set -g fish_pager_color_selected_background --background=302127
    set -g fish_ellipsis '...'
    set -g fish_truncation_char '.'
    set -g VIRTUAL_ENV_DISABLE_PROMPT 1
end
