#!/bin/bash
# RTM TV2 - Extract URL and Play with VLC (Raspberry Pi)
# All-in-one script

echo "=================================================="
echo "RTM TV2 Extract and Play (Raspberry Pi)"
echo "=================================================="
echo ""

# Get script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Step 1: Extracting URL..."
echo ""

# Run extractor
if ! "$script_dir/extract-rtm-url.sh"; then
    echo ""
    echo "Failed to extract URL."
    exit 1
fi

echo ""
echo "=================================================="
echo "Step 2: Launching VLC..."
echo "=================================================="
echo ""

# Small delay
sleep 2

# Launch VLC player
exec "$script_dir/play-vlc.sh"

