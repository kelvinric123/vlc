#!/bin/bash
################################################################################
# RTM TV2 Autostart Script
# This script starts the VLC player on boot and keeps it on top
################################################################################

# Get script directory (compatible with both bash and sh)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Log file
LOG_FILE="$SCRIPT_DIR/autostart.log"

# Log startup
echo "$(date): RTM Autostart initiated" >> "$LOG_FILE"

# Wait for the desktop environment and queuescreen to load first
# This ensures VLC appears on top of the queuescreen
sleep 15

# Wait for network to be ready (important for stream extraction)
while ! ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1; do
    echo "$(date): Waiting for network..." >> "$LOG_FILE"
    sleep 2
done

echo "$(date): Network ready, starting VLC player..." >> "$LOG_FILE"

# Start the RTM player
"$SCRIPT_DIR/play-rtm-quick.sh" >> "$LOG_FILE" 2>&1

echo "$(date): VLC player started" >> "$LOG_FILE"

