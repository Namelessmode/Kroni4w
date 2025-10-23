#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
    pkill -SIGUSR2 swaync # reloads Waybar config and style
    notify-send "Waybar reloaded"
else
    waybar & disown
    swaync & disown
    notify-send "Waybar launched"
fi
