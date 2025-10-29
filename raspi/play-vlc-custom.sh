#!/bin/bash
# RTM TV2 VLC Player - Raspberry Pi Version (Custom Size)
# Edit WIDTH, HEIGHT, POS_X, POS_Y below to customize

echo "=================================================="
echo "RTM TV2 VLC Player (Custom Size - Raspberry Pi)"
echo "=================================================="
echo ""

### CUSTOMIZE THESE VALUES ###
# Window will open in WINDOWED mode (not fullscreen)
# After seeing the window, adjust these values to your preference
WIDTH=640
HEIGHT=480
POS_X=0
POS_Y=0
### END CUSTOMIZATION ###

# Get script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
url_file="$script_dir/url.txt"

# Check if url.txt exists
if [ ! -f "$url_file" ]; then
    echo "❌ Error: url.txt not found!"
    echo "Please run: ./extract-rtm-url.sh first"
    exit 1
fi

# Read URL from file
STREAM_URL=$(cat "$url_file")

if [ -z "$STREAM_URL" ]; then
    echo "❌ Error: url.txt is empty!"
    exit 1
fi

echo "Stream URL: $STREAM_URL"
echo ""

# Check if VLC is installed (try cvlc first, then vlc)
VLC_CMD=""
if command -v cvlc &> /dev/null; then
    VLC_CMD="cvlc"
elif command -v vlc &> /dev/null; then
    VLC_CMD="vlc -I dummy"
else
    echo "❌ Error: VLC not found!"
    echo ""
    echo "Install VLC with:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install vlc"
    echo ""
    exit 1
fi

echo "Window Settings:"
echo "  Size: ${WIDTH}x${HEIGHT}"
echo "  Position: ($POS_X, $POS_Y)"
echo "Using: $VLC_CMD"
echo ""
echo "Starting VLC..."
echo ""

# Launch VLC with custom settings
$VLC_CMD \
    --no-embedded-video \
    --width=$WIDTH \
    --height=$HEIGHT \
    --video-x=$POS_X \
    --video-y=$POS_Y \
    --video-on-top \
    --no-video-deco \
    "$STREAM_URL"

echo ""
echo "VLC closed."

