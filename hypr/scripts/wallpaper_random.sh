#!/usr/bin/env bash

wallpapers_dir="$HOME/Pictures/wallpapers"

random_wallpaper=$(find "$wallpapers_dir" -maxdepth 1 -type f | shuf -n 1)

~/.config/hypr/scripts/walselector.sh "$random_wallpaper"
