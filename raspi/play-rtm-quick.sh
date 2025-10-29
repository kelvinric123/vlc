#!/bin/bash
################################################################################
# RTM TV2 Quick Player - One Command Solution (Queue Screen)
# For Raspberry Pi with VLC 3.0.17
# 
# Custom sized for queue screen layout - adjust dimensions below if needed
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Queue Screen Video Dimensions (measured from your layout)
# For 1920x1080 screen with right panel (~250px) and bottom bar (~150px)
VIDEO_WIDTH=1670    # Adjust if VLC is too wide
VIDEO_HEIGHT=930    # Adjust if VLC is too tall
VIDEO_X=0           # X position
VIDEO_Y=0           # Y position

# Extract URL and play in one go
python3 "$PARENT_DIR/extract-rtm-url.py" && \
pkill -9 vlc 2>/dev/null; \
sleep 1; \
cvlc \
    --width=$VIDEO_WIDTH \
    --height=$VIDEO_HEIGHT \
    --video-x=$VIDEO_X \
    --video-y=$VIDEO_Y \
    --no-video-title-show \
    --no-video-deco \
    --no-embedded-video \
    --no-autoscale \
    --video-on-top \
    --no-qt-video-autoresize \
    --zoom=1 \
    --network-caching=2000 \
    --http-reconnect \
    --loop \
    "$(cat $PARENT_DIR/url.txt)" 2>/dev/null &

VLC_PID=$!

# Wait a moment for VLC window to appear
sleep 2

# Ensure VLC window stays on top using wmctrl (if available)
if command -v wmctrl &> /dev/null; then
    wmctrl -r "VLC" -b add,above 2>/dev/null || true
fi

echo "VLC started! Playing RTM TV2 at ${VIDEO_WIDTH}x${VIDEO_HEIGHT}"
echo "Press Ctrl+C to stop, or run: pkill vlc"
echo ""
echo "If VLC doesn't fit perfectly, edit this script and adjust:"
echo "  VIDEO_WIDTH (line 13) - decrease if too wide"
echo "  VIDEO_HEIGHT (line 14) - decrease if too tall"

