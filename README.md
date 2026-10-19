# GlossyGlass

A dark glass theme for kitty and Fish. Pastel red accents, readable text, comfortable padding, and no decorative Unicode.

The full current directory appears above an empty command line. Startup is quiet: no greeting, system stats, images, Git badges, or prompt framework.

## Install

On Linux, run:

```bash
git clone https://github.com/liwwyy/GlossyGlass-kitty-theme.git
cd GlossyGlass-kitty-theme
./install.sh
```

Open a new kitty window after installation.

The script installs missing kitty, Fish, and fontconfig packages using apt, pacman, dnf, or zypper. Package installation may ask for your sudo password. It validates the theme, backs up your entire kitty and Fish configuration directories, then replaces them. This resets existing plugins and prompt customizations. Your login shell stays unchanged; kitty launches Fish directly.

Use a recent kitty version with animated cursor blink and cursor trail support. The installer checks the options with your installed kitty parser before replacing your configs. If validation fails, update kitty and rerun.

## Appearance

- Near-black `#0b090b` background at 90% opacity.
- Adwaita Mono, 12.5 points, with fontconfig's monospace fallback when unavailable.
- 16-point padding on every side.
- Pastel-red directory and bold command names.
- Blue arguments, cyan options and escapes, green strings, gold operators, mauve redirections, and bright red errors.
- Muted suggestions and comments, with visible selection and completion colors.
- Smooth cursor trail and gently fading cursor blink, which stops after 15 seconds of inactivity.
- Plain text tabs and prompt, without icons or powerline characters.

Fish applies syntax colors as you type. Applications control their own output colors; the included ANSI palette gives standard terminal colors a matching pastel appearance. Filenames retain their actual characters.

Background blur is requested through kitty's compositor extension. Frosted blur requires compositor support; transparency works independently. A dark wallpaper keeps the glass effect dark. Window opening animations and smooth scrolling depend on the compositor or application, rather than this theme.

## Adjust

Edit `~/.config/kitty/kitty.conf`:

| Setting | Default |
| --- | --- |
| `background_opacity` | `0.90` (lower means more transparent) |
| `background_blur` | `24` |
| `font_size` | `12.5` |
| `window_padding_width` | `16` |
| `cursor_trail` | `3` (set to `0` to disable) |
| `cursor_blink_interval` | `0.65 ease-in-out` (set to `0` for a steady cursor) |

Colors are in `~/.config/kitty/theme.conf` and `~/.config/fish/config.fish`. The prompt is in `~/.config/fish/functions/fish_prompt.fish`.

## Restore

Every installation prints its backup location. The latest location is also stored in `${XDG_STATE_HOME:-$HOME/.local/state}/glossyglass/latest-backup`.

Close other Fish terminals, then run from Bash:

```bash
./install.sh --restore /path/to/backup
```

Restoring saves the current configs in a separate backup first. The installer respects `XDG_CONFIG_HOME` and `XDG_STATE_HOME`.
