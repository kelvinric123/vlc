#!/bin/bash
# RTM TV2 VLC Player - Raspberry Pi Version (Fullscreen)

echo "=================================================="
echo "RTM TV2 VLC Player (Fullscreen - Raspberry Pi)"
echo "=================================================="
echo ""

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

# Check if VLC is installed
if ! command -v cvlc &> /dev/null; then
    echo "❌ Error: VLC not found!"
    echo ""
    echo "Install VLC with:"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install vlc"
    echo ""
    exit 1
fi

echo "Starting VLC in FULLSCREEN mode..."
echo ""

# Launch VLC in fullscreen
cvlc \
    --fullscreen \
    --video-on-top \
    --no-video-deco \
    "$STREAM_URL"

echo ""
echo "VLC closed."

