#!/bin/bash

for i in {0..3}; do
  if [ -f /sys/class/power_supply/BAT$i/capacity ]; then
    battery_level=$(cat /sys/class/power_supply/BAT$i/status)
    battery_capacity=$(cat /sys/class/power_supply/BAT$i/capacity)
    battery_level2=$(cat /sys/class/power_supply/BAT0/status)
    battery_capacity2=$(cat /sys/class/power_supply/BAT0/capacity)
    echo "Battery: $battery_capacity% $battery_capacity2% ($battery_level) ($battery_level2)"
  fi
done
