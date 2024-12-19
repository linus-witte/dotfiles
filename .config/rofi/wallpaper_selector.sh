#!/bin/bash
# Directory containing your wallpapers
WALLPAPER_DIR=~/.config/i3/wallpapers

# Generate a list of wallpapers and display them in rofi
SELECTED=$(ls "$WALLPAPER_DIR" | rofi -dmenu -i -p "Select Wallpaper")

# If a selection is made, preview the wallpaper with feh and set it
if [[ -n "$SELECTED" ]]; then
    feh --bg-fill "$WALLPAPER_DIR/$SELECTED" &
    notify-send "Wallpaper Set" "$SELECTED"  # Optional: notify of the change
fi

