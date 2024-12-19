#!/bin/bash
# Directory containing your wallpapers
WALLPAPER_DIR=~/.config/i3/wallpapers

SELECTED=$(ls "$WALLPAPER_DIR" | fzf --preview 'feh --bg-fill --scale-down "~/.config/i3/wallpapers/{}"' --height 40% --border)

# Apply wallpaper if selection is made
if [[ -n "$SELECTED" ]]; then
    feh --bg-fill "$WALLPAPER_DIR/$SELECTED"
    notify-send "Wallpaper Set" "$SELECTED"
fi
