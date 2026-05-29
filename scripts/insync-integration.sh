#!/usr/bin/env bash

# Insync Status Script for Waybar (Arch Linux version)
# --------------------------------------------------
# This script checks the Insync logs database to determine
# if syncing is active and outputs JSON for Waybar.
# --------------------------------------------------

# Path to the Insync logs database
INS_LOGS_DB="$HOME/.config/Insync/logs.db"

# KEYWORDS: Log phrases indicating active syncing
SYNCING_KEYWORDS="AddCloudGDItem|ADD|download|processing|queue|RemoveCloudGDItem|DELETE"

# --- Status Checks ---

# Check if Insync is running
if ! pgrep -x insync > /dev/null; then
    echo "{\"text\": \"<span size='17000'></span>\", \"tooltip\": \"Insync is not running\", \"class\": \"error\"}"
    exit 0
fi

# Check for active syncing using log messages from SQLite DB
if [ -f "$INS_LOGS_DB" ]; then
    SYNCING_COUNT=$(sqlite3 "$INS_LOGS_DB" "SELECT message FROM logs ORDER BY created DESC LIMIT 10;" \
        | grep -E -i "$SYNCING_KEYWORDS" \
        | wc -l)
else
    SYNCING_COUNT=0
fi
                
# --- Process and Output Status ---

ICON="<span size='17000'>󰅟</span>"
CLASS="synced"
TOOLTIP_TEXT="Insync: All files synced"

if [ "$SYNCING_COUNT" -gt 0 ]; then
    ICON="<span size='17000'>󰘿</span>" # Cloud with spinning arrows
    CLASS="syncing"
    TOOLTIP_TEXT="Insync is currently syncing..."
fi

# --- Output the result as JSON for Waybar ---
JSON_OUTPUT="{\"text\": \"$ICON\", \"tooltip\": \"$TOOLTIP_TEXT\", \"class\": \"$CLASS\"}"
echo "$JSON_OUTPUT"
