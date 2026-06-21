#!/usr/bin/env bash
set -euo pipefail

primary_monitor="DP-4"
left_monitor="DP-2"
right_monitor="HDMI-0"

connected_outputs=$(xrandr --query | awk '/ connected/ { print $1 }')

if grep -qx "$primary_monitor" <<< "$connected_outputs" &&
    grep -qx "$left_monitor" <<< "$connected_outputs" &&
    grep -qx "$right_monitor" <<< "$connected_outputs"; then
    xrandr \
        --output "$primary_monitor" --mode 1920x1080 --rate 144 --primary \
        --output "$left_monitor" --mode 1920x1080 --rate 144 --left-of "$primary_monitor" \
        --output "$right_monitor" --mode 1920x1080 --rate 60 --right-of "$primary_monitor"
else
    xrandr --auto
fi
