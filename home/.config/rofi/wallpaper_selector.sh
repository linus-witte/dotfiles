#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/i3/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send "Wallpaper selector" "Directory not found: $WALLPAPER_DIR"
    exit 1
fi

SELECTED=$(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname '*.avif' -o -iname '*.bmp' -o -iname '*.gif' -o -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%f\n' |
        sort |
        rofi -dmenu -i -p "Select Wallpaper"
)

if [[ -z "$SELECTED" ]]; then
    exit 0
fi

feh --bg-fill "$WALLPAPER_DIR/$SELECTED"
notify-send "Wallpaper Set" "$SELECTED"
