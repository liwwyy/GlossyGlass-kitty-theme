# GlossyGlass

A dark glass theme for kitty, Fish, and Micro. Pastel red accents, readable text, comfortable padding, and no decorative Unicode.

The full current directory appears above a cyan `> ` input prompt. Active Python virtual environments and Conda environments appear in mauve beside the directory, for example `[venv: project/.venv]`. Use `deactivate` to leave a Python virtual environment. Startup is quiet: no greeting, system stats, images, Git badges, or prompt framework.

## Install

On Linux, run:

```bash
git clone https://github.com/liwwyy/GlossyGlass-kitty-theme.git
cd GlossyGlass-kitty-theme
./install.sh
```

Open a new kitty window after installation.

The script installs missing kitty, Fish, Micro, fontconfig, and Python packages using apt, pacman, dnf, or zypper. Package installation may ask for your sudo password. It validates the theme, backs up your entire kitty, Fish, Micro, and Fastfetch configuration directories, then replaces them. This resets existing kitty and Fish plugins and prompt customizations. Micro keeps its plugins, bindings, and other settings; only the colorscheme is selected. Your login shell stays unchanged; kitty launches Fish directly.

Use a recent kitty version with animated cursor blink, smooth scrolling, and the built-in `cursor-trail-motion-blur` shader (tested with kitty 0.49.2). The installer checks the options with your installed kitty parser before replacing your configs. If validation fails, update kitty and rerun.

## Appearance

- Near-black `#0b090b` background at 90% opacity.
- Adwaita Mono, 12.5 points, with fontconfig's monospace fallback when unavailable.
- 16-point padding on every side.
- Pastel-red directory and bold command names.
- Blue arguments, cyan options and escapes, green strings, gold operators, mauve redirections, and bright red errors.
- Muted suggestions and comments, with visible selection and completion colors.
- Motion-blurred cursor trails during typing, deletion, and line changes; gently fading cursor blink stops after 15 seconds of inactivity.
- Smooth pixel scrolling and touchpad momentum in kitty scrollback. Ctrl+Shift+Up/Down and Ctrl+Shift+PageUp/PageDown also scroll smoothly.
- Matching Micro syntax, selection, search, tabs, status bar, line numbers, and diff colors, with terminal background transparency.
- Plain text tabs and prompt, without icons or powerline characters.

Fish applies syntax colors as you type. Applications control their own output colors; the included ANSI palette gives standard terminal colors a matching pastel appearance. Filenames retain their actual characters.

Background blur is requested through kitty's compositor extension. Frosted blur requires compositor support; transparency works independently. A dark wallpaper keeps the glass effect dark. Window opening and resizing animations depend on the compositor. Full-screen applications manage their own scrolling and may override cursor blinking. Kitty does not provide per-letter fade or slide effects for inserting/deleting text, or animation of whole rows when a newline is inserted; the animated effect follows cursor movement instead. The 1 ms trail trigger can skip cursor positions held for less than that interval during fast updates.

Animation uses kitty's built-in [cursor motion-blur shader](https://sw.kovidgoyal.net/kitty/custom-shaders/); no artificial input delays or shell repaint loops are added.

## Adjust

Edit `~/.config/kitty/kitty.conf`:

| Setting | Default |
| --- | --- |
| `background_opacity` | `0.90` (lower means more transparent) |
| `background_blur` | `24` |
| `font_size` | `12.5` |
| `window_padding_width` | `16` |
| `cursor_trail` | `1` (set to `0` to disable) |
| `cursor_blink_interval` | `0.65 ease-in-out` (set to `0` for a steady cursor) |

Colors are in `~/.config/kitty/theme.conf` and `~/.config/fish/config.fish`. The prompt is in `~/.config/fish/functions/fish_prompt.fish`.

## Micro editor

The installer adds `~/.config/micro/colorschemes/glossyglass.micro` and selects it in Micro's `settings.json`, preserving unrelated settings. Reopen Micro after installing.

For a manual theme-only install:

```bash
mkdir -p ~/.config/micro/colorschemes
cp micro/colorschemes/glossyglass.micro ~/.config/micro/colorschemes/
```

Then press Ctrl+E inside Micro and enter:

```text
set colorscheme glossyglass
```

The theme inherits the terminal's default foreground and background so the main editing area stays translucent. Syntax and interface elements use the GlossyGlass pastel palette. See [Micro's colorscheme documentation](https://github.com/micro-editor/micro/blob/master/runtime/help/colors.md).

## Fastfetch

Fastfetch stays manual: run `fastfetch` when you want it. It is never launched by the shell config. If Fastfetch is already installed, the included config is ready to use; install the executable with your package manager if needed.

The installer backs up Fastfetch and replaces its main `config.jsonc`, while keeping additional logo files and assets. Its `logo.position` is `auto`: narrow windows stack the logo above system details, and wide windows display them side by side. Tested with Fastfetch 2.69.0 at 60, 80, and 160 columns. After resizing, clear the terminal and rerun Fastfetch; printed output does not redraw its layout.

Edit the installed settings with:

```bash
micro ~/.config/fastfetch/config.jsonc
```

The default logo is your distribution's built-in ASCII art, rather than a separate image file. Browse built-in choices with `fastfetch --list-logos` or preview them with `fastfetch --print-logos`.

To export your CachyOS logo as editable plain text:

```bash
fastfetch --logo CachyOS --structure logo --pipe true > ~/.config/fastfetch/logo.txt
micro ~/.config/fastfetch/logo.txt
```

Then change the `logo` section in `config.jsonc` to:

```json
"logo": {
    "type": "file",
    "source": "~/.config/fastfetch/logo.txt",
    "position": "auto",
    "padding": { "right": 3 }
}
```

For an image, use your own PNG, JPG, or artwork from its creator's download page. Edit it with GIMP or Krita, save it as `~/.config/fastfetch/logo.png`, then use:

```json
"logo": {
    "type": "kitty",
    "source": "~/.config/fastfetch/logo.png",
    "width": 20,
    "height": 10,
    "position": "auto",
    "padding": { "right": 3 }
}
```

Width and height are terminal columns and rows. Adjust both to suit the image proportions. Use `position: "top"` for an always-stacked layout, or `type: "small"` for a smaller built-in distro logo. See the official [logo options](https://github.com/fastfetch-cli/fastfetch/wiki/Logo-options) and [configuration guide](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration).

## Restore

Every installation prints its backup location. The latest location is also stored in `${XDG_STATE_HOME:-$HOME/.local/state}/glossyglass/latest-backup`.

Close other Fish terminals, then run from Bash:

```bash
./install.sh --restore /path/to/backup
```

Restoring saves the current configs in a separate backup first. The installer respects `XDG_CONFIG_HOME` and `XDG_STATE_HOME`.
