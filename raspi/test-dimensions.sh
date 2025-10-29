#!/bin/bash
################################################################################
# Test VLC Window Dimensions for Queue Screen
# 
# This script helps you find the perfect dimensions for your queue screen.
# It displays a test video at the specified size so you can verify the fit.
################################################################################

# Default dimensions (edit these to test different sizes)
WIDTH=${1:-1670}
HEIGHT=${2:-930}
X_POS=${3:-0}
Y_POS=${4:-0}

echo "=============================================="
echo "  Queue Screen Dimension Tester"
echo "=============================================="
echo ""
echo "Testing dimensions:"
echo "  Width:  ${WIDTH}px"
echo "  Height: ${HEIGHT}px"
echo "  X Position: ${X_POS}px"
echo "  Y Position: ${Y_POS}px"
echo ""
echo "Usage: $0 [width] [height] [x] [y]"
echo "Example: $0 1670 930 0 0"
echo ""
echo "Press Ctrl+C to stop the test"
echo "=============================================="
echo ""

# Kill any existing VLC
pkill -9 vlc 2>/dev/null || true
sleep 1

# Create a simple test pattern using VLC's fake video
if command -v cvlc &> /dev/null; then
    VLC_CMD="cvlc"
else
    VLC_CMD="vlc"
fi

# Generate a color test pattern with VLC
$VLC_CMD \
    --width=$WIDTH \
    --height=$HEIGHT \
    --video-x=$X_POS \
    --video-y=$Y_POS \
    --no-video-title-show \
    --no-video-deco \
    --no-embedded-video \
    --video-filter=gradient \
    --gradient-mode=gradient \
    --gradient-type=0 \
    fake://

echo ""
echo "Test complete. Adjust dimensions in extract-and-play-reliable.sh if needed."

