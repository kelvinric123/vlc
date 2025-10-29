#!/bin/bash
################################################################################
# Screen Dimension Measurement Helper
# 
# This script attempts to detect your screen resolution and suggests
# dimensions for the queue screen video player.
################################################################################

echo "=============================================="
echo "  Queue Screen Dimension Helper"
echo "=============================================="
echo ""

# Try to detect screen resolution
echo "Detecting screen resolution..."
echo ""

# Method 1: xrandr (most common)
if command -v xrandr &> /dev/null; then
    RESOLUTION=$(xrandr | grep '\*' | awk '{print $1}' | head -n1)
    if [ ! -z "$RESOLUTION" ]; then
        SCREEN_WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
        SCREEN_HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)
        echo "✓ Detected resolution: ${SCREEN_WIDTH}x${SCREEN_HEIGHT} (via xrandr)"
    fi
fi

# Method 2: xdpyinfo (fallback)
if [ -z "$SCREEN_WIDTH" ] && command -v xdpyinfo &> /dev/null; then
    SCREEN_WIDTH=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f1)
    SCREEN_HEIGHT=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f2)
    if [ ! -z "$SCREEN_WIDTH" ]; then
        echo "✓ Detected resolution: ${SCREEN_WIDTH}x${SCREEN_HEIGHT} (via xdpyinfo)"
    fi
fi

# Method 3: fbset (for framebuffer)
if [ -z "$SCREEN_WIDTH" ] && command -v fbset &> /dev/null; then
    SCREEN_WIDTH=$(fbset -s | grep geometry | awk '{print $2}')
    SCREEN_HEIGHT=$(fbset -s | grep geometry | awk '{print $3}')
    if [ ! -z "$SCREEN_WIDTH" ]; then
        echo "✓ Detected resolution: ${SCREEN_WIDTH}x${SCREEN_HEIGHT} (via fbset)"
    fi
fi

# Manual input if detection failed
if [ -z "$SCREEN_WIDTH" ]; then
    echo "⚠ Could not auto-detect screen resolution"
    echo ""
    read -p "Enter screen width (e.g., 1920): " SCREEN_WIDTH
    read -p "Enter screen height (e.g., 1080): " SCREEN_HEIGHT
fi

echo ""
echo "=============================================="
echo "  Your Screen: ${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
echo "=============================================="
echo ""

# Default panel sizes
DEFAULT_RIGHT_PANEL=250
DEFAULT_BOTTOM_BAR=150

echo "Now, let's calculate the video area dimensions."
echo ""
echo "Based on your queue screen layout:"
read -p "Right panel width in pixels (default: $DEFAULT_RIGHT_PANEL): " RIGHT_PANEL
RIGHT_PANEL=${RIGHT_PANEL:-$DEFAULT_RIGHT_PANEL}

read -p "Bottom bar height in pixels (default: $DEFAULT_BOTTOM_BAR): " BOTTOM_BAR
BOTTOM_BAR=${BOTTOM_BAR:-$DEFAULT_BOTTOM_BAR}

# Calculate video dimensions
VIDEO_WIDTH=$((SCREEN_WIDTH - RIGHT_PANEL))
VIDEO_HEIGHT=$((SCREEN_HEIGHT - BOTTOM_BAR))

echo ""
echo "=============================================="
echo "  RECOMMENDED SETTINGS"
echo "=============================================="
echo ""
echo "Add these values to extract-and-play-reliable.sh:"
echo ""
echo "VIDEO_WIDTH=$VIDEO_WIDTH"
echo "VIDEO_HEIGHT=$VIDEO_HEIGHT"
echo "VIDEO_X=0"
echo "VIDEO_Y=0"
echo ""
echo "=============================================="
echo ""
echo "Calculations:"
echo "  Video width:  $SCREEN_WIDTH - $RIGHT_PANEL = $VIDEO_WIDTH"
echo "  Video height: $SCREEN_HEIGHT - $BOTTOM_BAR = $VIDEO_HEIGHT"
echo ""
echo "Next steps:"
echo "1. Edit extract-and-play-reliable.sh"
echo "2. Update the VIDEO_WIDTH and VIDEO_HEIGHT values (around line 49)"
echo "3. Test with: ./test-dimensions.sh $VIDEO_WIDTH $VIDEO_HEIGHT 0 0"
echo "4. Fine-tune if needed"
echo ""

