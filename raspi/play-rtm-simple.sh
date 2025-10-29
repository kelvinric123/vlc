#!/bin/bash
################################################################################
# RTM TV2 Simple Player for Raspberry Pi
# VLC Version: 3.0.17
# 
# Simple one-command solution: Extract URL and play immediately
################################################################################

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=============================================="
echo "  RTM TV2 Simple Player for Raspberry Pi"
echo "=============================================="
echo ""

# Step 1: Extract URL
echo "[1/3] Extracting stream URL..."
python3 "$PARENT_DIR/extract-rtm-url.py"

if [ $? -ne 0 ] || [ ! -f "$PARENT_DIR/url.txt" ]; then
    echo "ERROR: Failed to extract URL"
    exit 1
fi

STREAM_URL=$(cat "$PARENT_DIR/url.txt")
echo "✓ Got URL: $STREAM_URL"
echo ""

# Step 2: Kill existing VLC
echo "[2/3] Stopping any existing VLC..."
pkill -9 vlc 2>/dev/null || true
sleep 1
echo "✓ Ready to play"
echo ""

# Step 3: Play with VLC
echo "[3/3] Starting VLC..."
echo ""

# Use cvlc (command-line VLC) if available, otherwise vlc
if command -v cvlc &> /dev/null; then
    cvlc \
        --fullscreen \
        --no-video-title-show \
        --network-caching=2000 \
        --live-caching=2000 \
        --http-reconnect \
        --loop \
        "$STREAM_URL"
else
    vlc \
        --fullscreen \
        --no-video-title-show \
        --network-caching=2000 \
        --live-caching=2000 \
        --http-reconnect \
        --loop \
        "$STREAM_URL"
fi

