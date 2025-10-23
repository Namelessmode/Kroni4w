#!/bin/bash


set -e

# ────────────────────────────────────────────────
# Configuration
WALL_DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$HOME/.cache/rofi-wallpapers"
mkdir -p "$CACHE_DIR"
BLURRED_DIR="$CACHE_DIR/blurred"
mkdir -p "$BLURRED_DIR"
ROFI_THEME="$HOME/.config/rofi/config-wallpaper.rasi"

# Blur & effect config
BLUR_FILE="$HOME/.config/walsec/blur.sh"
BLUR_DEFAULT="50x30"
[ -f "$BLUR_FILE" ] && BLUR=$(cat "$BLUR_FILE") || BLUR="$BLUR_DEFAULT"

# ────────────────────────────────────────────────
# Logging helper
log() { echo "[walsec] $1"; }

# ────────────────────────────────────────────────
# Apply wallpaper + blur + cache + color sync
apply_wallpaper() {
    local img="$1"
    if [ -z "$img" ] || [ ! -f "$img" ]; then
        notify-send "Invalid wallpaper" "File not found: $img"
        exit 1
    fi

    local base="$(basename "$img")"
    local blurred="$BLURRED_DIR/blurred-${base%.*}.png"
    local rasifile="$CACHE_DIR/current_wallpaper.rasi"

    # Apply wallpaper with transition
    log "Applying wallpaper: $img"
    swww img "$img" -t any --transition-bezier .43,1.19,1,.4 --transition-duration 1 --transition-fps 120
    sleep 0.8

    wal -i "$img" && matugen image "$img"
    pkill swaync 1>/dev/null || true
    swaync & disown
    #notify-send "Wallpaper applied" -i "$img"

    # Generate blurred wallpaper (cache-aware)
    if [ ! -f "$blurred" ]; then
        log "Creating blurred wallpaper..."
        magick "$img" -resize 75% "$blurred"
        [ "$BLUR" != "0x0" ] && magick "$blurred" -blur "$BLUR" "$blurred"
    fi

    # Generate Rofi .rasi file for background blur
    echo "* { current-image: url(\"$blurred\", height); }" > "$rasifile"
   
    # Symlink Wallpaper to Wlogout
    ln -sf "$blurred" "$HOME/.config/wlogout/wallpaper_blurred.png"
    ln -sf "$img" "$HOME/.config/rofi/shared/current-wallpaper.png"
   
    pkill rofi 2>/dev/null || true

    notify-send "Wallpaper Theme applied" -i "$img"
    hyprctl reload
    ~/.config/hypr/scripts/cava-pywal.sh
}

# ────────────────────────────────────────────────
# Interactive wallpaper picker
choose_wallpaper() {
    mapfile -d '' files < <(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) -print0)

    menu() {
        for f in "${files[@]}"; do
            name=$(basename "$f")
            thumb="$CACHE_DIR/thumb-${name%.*}.png"
            [ ! -f "$thumb" ] && magick "$f" -resize 400x225 "$thumb"
            printf "%s\x00icon\x1f%s\n" "$name" "$thumb"
        done
    }

    choice=$(menu | rofi -dmenu -i -p "Wallpaper" -config "$ROFI_THEME" -theme-str 'element-icon{size:33%;}')
    [ -z "$choice" ] && exit 0
    apply_wallpaper "$WALL_DIR/$choice"
}

# ────────────────────────────────────────────────
# Main
if [ -n "$1" ]; then
    apply_wallpaper "$1"
else
    choose_wallpaper
fi

