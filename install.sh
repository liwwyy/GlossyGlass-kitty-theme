#!/usr/bin/env bash
# Install or restore GlossyGlass. Every installation preserves existing configs.
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
state_dir=${XDG_STATE_HOME:-"$HOME/.local/state"}/glossyglass

if [[ ${1:-} == --restore ]]; then
    backup=${2:?Usage: ./install.sh --restore BACKUP_DIRECTORY}
    apps=(kitty fish)
    # Restore optional app configs only when present in that backup.
    for optional_app in micro fastfetch; do
        if [[ -d "$backup/$optional_app" || -f "$backup/$optional_app.absent" ]]; then apps+=("$optional_app"); fi
    done
    for app in "${apps[@]}"; do
        [[ -d "$backup/$app" || -f "$backup/$app.absent" ]] || { echo "Invalid backup: $backup" >&2; exit 1; }
    done
    saved="$state_dir/backups/pre-restore-$(date +%Y%m%d-%H%M%S)-$$"
    mkdir -p "$saved" "$config_dir"
    for app in "${apps[@]}"; do
        if [[ -e "$config_dir/$app" || -L "$config_dir/$app" ]]; then
            mv -- "$config_dir/$app" "$saved/$app"
        else
            touch "$saved/$app.absent"
        fi
        if [[ -d "$backup/$app" ]]; then cp -a -- "$backup/$app" "$config_dir/$app"; fi
    done
    printf 'Restored. Replaced configs saved to: %s\nOpen a new kitty window.\n' "$saved"
    exit 0
fi
if [[ $# -gt 0 ]]; then echo 'Usage: ./install.sh [--restore BACKUP_DIRECTORY]' >&2; exit 1; fi

# Install missing runtime dependencies using the system package manager.
if ! command -v kitty >/dev/null || ! command -v fish >/dev/null || ! command -v fc-match >/dev/null || ! command -v micro >/dev/null || ! command -v python3 >/dev/null; then
    privilege=()
    if [[ $EUID -ne 0 ]]; then privilege=(sudo); fi
    if command -v pacman >/dev/null; then
        "${privilege[@]}" pacman -S --needed --noconfirm kitty fish micro fontconfig python
    elif command -v apt-get >/dev/null; then
        "${privilege[@]}" apt-get update
        "${privilege[@]}" apt-get install -y kitty fish micro fontconfig python3
    elif command -v dnf >/dev/null; then
        "${privilege[@]}" dnf install -y kitty fish micro fontconfig python3
    elif command -v zypper >/dev/null; then
        "${privilege[@]}" zypper --non-interactive install kitty fish micro fontconfig python3
    else
        echo 'Install kitty, fish, and fontconfig with your package manager, then rerun.' >&2
        exit 1
    fi
fi

# Validate before replacing any configuration. Older kitty versions may not
# support the animation options; fail with their parser diagnostics.
fish --no-execute "$source_dir/fish/config.fish" "$source_dir"/fish/functions/*.fish
GLOSSYGLASS_SOURCE="$source_dir" kitty +runpy 'import os; from kitty.config import load_config; errors = []; load_config(os.path.join(os.environ["GLOSSYGLASS_SOURCE"], "kitty/kitty.conf"), accumulate_bad_lines=errors); print("kitty configuration:", errors or "OK"); raise SystemExit(1 if errors else 0)'

backup="$state_dir/backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup" "$config_dir"
# Stage all configs before touching the current installation.
staging=$(mktemp -d "$config_dir/.glossyglass.XXXXXXXX")
trap 'rm -rf -- "$staging"' EXIT
cp -R -- "$source_dir/kitty" "$source_dir/fish" "$staging/"
# Keep Micro plugins, bindings, and unrelated settings.
if [[ -d "$config_dir/micro" ]]; then
    cp -aL -- "$config_dir/micro" "$staging/micro"
fi
mkdir -p "$staging/micro/colorschemes"
cp -- "$source_dir/micro/colorschemes/glossyglass.micro" "$staging/micro/colorschemes/"
python3 - "$staging/micro/settings.json" <<'PYSETTINGS'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
settings = json.loads(p.read_text()) if p.exists() else {}
settings.update(colorscheme="glossyglass")
p.write_text(json.dumps(settings, indent=4) + "\n")
PYSETTINGS
# Preserve additional Fastfetch assets and replace only its main theme config.
if [[ -d "$config_dir/fastfetch" ]]; then
    cp -aL -- "$config_dir/fastfetch" "$staging/fastfetch"
fi
mkdir -p "$staging/fastfetch"
cp -- "$source_dir/fastfetch/config.jsonc" "$staging/fastfetch/config.jsonc"
# Fontconfig selects a readable monospace fallback if Adwaita Mono is absent.
font=$(fc-match -f '%{family}' 'Adwaita Mono' | head -c 200)
printf 'Font: %s\n' "$font"
for app in kitty fish micro fastfetch; do
    if [[ -e "$config_dir/$app" || -L "$config_dir/$app" ]]; then
        cp -a -- "$config_dir/$app" "$backup/$app"
    else
        touch "$backup/$app.absent"
    fi
done
for app in kitty fish micro fastfetch; do
    rm -rf -- "$config_dir/$app"
    mv -- "$staging/$app" "$config_dir/$app"
done
printf '%s\n' "$backup" > "$state_dir/latest-backup"
printf 'Installed GlossyGlass. Backup: %s\nOpen a new kitty window.\nRestore: ./install.sh --restore "%s"\n' "$backup" "$backup"
