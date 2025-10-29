#!/bin/bash
################################################################################
# RTM TV2 Quick Player - One Command Solution
# For Raspberry Pi with VLC 3.0.17
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Extract URL and play in one go
python3 "$PARENT_DIR/extract-rtm-url.py" && \
pkill -9 vlc 2>/dev/null; \
sleep 1; \
cvlc --fullscreen --no-video-title-show --network-caching=2000 --http-reconnect --loop "$(cat $PARENT_DIR/url.txt)" 2>/dev/null &

echo "VLC started! Playing RTM TV2 in fullscreen."
echo "Press Ctrl+C to stop, or run: pkill vlc"

