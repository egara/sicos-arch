#!/usr/bin/env bash

# SicOS Shell Launcher
# --------------------
# Starts either DankMaterialShell (DMS) or Waybar + SwayNC
# depending on the configuration in ~/.config/sicos/shell_choice

CHOICE_FILE="$HOME/.config/sicos/shell_choice"

if [ -f "$CHOICE_FILE" ]; then
    SHELL_CHOICE=$(cat "$CHOICE_FILE" | tr -d '[:space:]')
else
    SHELL_CHOICE="dank-material-shell"
fi

if [ "$SHELL_CHOICE" = "waybar" ]; then
    # Stop DMS if running
    systemctl --user stop dms.service 2>/dev/null || pkill -f dms 2>/dev/null || true
    # Launch Waybar & SwayNC
    uwsm app -- waybar &
    uwsm app -- swaync &
else
    # Stop Waybar & SwayNC if running
    pkill waybar 2>/dev/null || true
    pkill swaync 2>/dev/null || true
    # Launch DankMaterialShell
    if systemctl --user list-unit-files | grep -q dms.service; then
        systemctl --user start dms.service
    else
        uwsm app -- dms &
    fi
fi
