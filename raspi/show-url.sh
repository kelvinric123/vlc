#!/bin/bash
# Display the current RTM TV2 stream URL

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
url_file="$script_dir/url.txt"

echo "=================================================="
echo "RTM TV2 Stream URL"
echo "=================================================="
echo ""

if [ -f "$url_file" ]; then
    cat "$url_file"
else
    echo "❌ Error: url.txt not found!"
    echo "Please run: ./extract-rtm-url.sh first"
fi

echo ""
echo "=================================================="

