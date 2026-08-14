#!/usr/bin/env bash

# Script for disabling the laptop screen in Hyrpland
# --------------------------------------------------
#
# @author: Eloy García Almadén
# @email: eloy.garcia.pca@gmail.com
# ------------------------------------------

# Running hyprctl monitors command and store the output
output=$(hyprctl monitors)

# Checking if the output contains "HDMI-" or "DP-"
if [[ "$output" == "HDMI-"* ] || [ "$output" == "DP-"* ]]; then
  if [[ $1 == "open" ]]; then
    hyprctl keyword monitor "eDP-1,highres,1920x0,1"
    echo "Lip is opened. Enabling laptop screen" | systemd-cat -p info
  else
    hyprctl keyword monitor "eDP-1,disable"
    echo "Lip is closed. Disabling laptop screen" | systemd-cat -p info
  fi

  # Checking if shell has crashed
  echo "Checking if shell has crashed" | systemd-cat -p info
  sleep 3
  if pgrep -x waybar >/dev/null || systemctl --user is-active --quiet dms.service || pgrep -x dms >/dev/null; then
    echo "Shell is OK. Skipping..." | systemd-cat -p info
  else
    echo "Shell has crashed. Restarting shell..." | systemd-cat -p info
    uwsm app -- ~/.config/sicos/scripts/start-shell.sh &
  fi  
else
    echo "No external monitor HDMI-* has been detected. Type hyprctl monitors to see active monitors and modify this script." | systemd-cat -p info
fi
