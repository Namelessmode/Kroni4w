#!/bin/bash

# Paths
CONFIG_DIR="$HOME/.config/hypr/scripts/profile-daemon"
PROFILE_FILE="$CONFIG_DIR/profile/current_profile"

# Function: Output Waybar JSON
function show_status() {
    PROFILE=$(cat "$PROFILE_FILE" 2>/dev/null)

    case "$PROFILE" in
        performance)
            ICON=""
            ;;
        balanced)
            ICON=""
            ;;
        *)
            ICON=""
            PROFILE="unknown"
            ;;
    esac

    echo "{\"text\": \"$ICON\", \"tooltip\": \"TLP profile: $PROFILE\"}"
}

# Function: Switch TLP profile
function switch_profile() {
    PROFILE="$1"

    if [[ "$PROFILE" == "next" ]]; then
        CURRENT=$(cat "$PROFILE_FILE" 2>/dev/null)
        case "$CURRENT" in
            performance) PROFILE="balanced" ;;
            balanced) PROFILE="saver" ;;
            saver) PROFILE="performance" ;;
            *) PROFILE="performance" ;;
        esac
    fi

    case "$PROFILE" in
        performance)
            sudo cp "$CONFIG_DIR/tlp-performance.conf" /etc/tlp.conf
            ;;
        balanced)
            sudo cp "$CONFIG_DIR/tlp-power.conf" /etc/tlp.conf
            ;;
        saver)
            sudo cp "$CONFIG_DIR/tlp-saver.conf" /etc/tlp.conf
            ;;
        *)
            echo "Invalid profile: $PROFILE"
            echo "Usage: $0 [performance|balanced|saver|next]"
            exit 1
            ;;
    esac

    sudo systemctl restart tlp
    mkdir -p "$(dirname "$PROFILE_FILE")"
    echo "$PROFILE" > "$PROFILE_FILE"
    echo "Switched to $PROFILE profile."
}

