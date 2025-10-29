#!/bin/bash
# Check VLC Installation on Raspberry Pi

echo "=================================================="
echo "VLC Installation Checker (Raspberry Pi)"
echo "=================================================="
echo ""

VLC_FOUND=0

echo "Checking for VLC installation..."
echo ""

# Check if cvlc (command-line VLC) is available
if command -v cvlc &> /dev/null; then
    VLC_FOUND=1
    echo "[+] Found: cvlc (command-line VLC)"
    VLC_PATH=$(which cvlc)
    echo "    Location: $VLC_PATH"
fi

# Check if vlc (GUI VLC) is available
if command -v vlc &> /dev/null; then
    VLC_FOUND=1
    echo "[+] Found: vlc (GUI version)"
    VLC_PATH=$(which vlc)
    echo "    Location: $VLC_PATH"
fi

echo ""
echo "=================================================="

if [ $VLC_FOUND -eq 1 ]; then
    echo "Status: VLC is installed! ✓"
    echo ""
    
    # Get VLC version
    echo "VLC Version:"
    cvlc --version 2>/dev/null | head -n 1 || vlc --version 2>/dev/null | head -n 1
    
    echo ""
    echo "You can now run:"
    echo "  ./play-vlc-simple.sh"
    echo "  ./play-vlc-custom.sh"
    echo "  ./play-vlc.sh"
else
    echo "Status: VLC NOT found! ✗"
    echo ""
    echo "To install VLC on Raspberry Pi:"
    echo ""
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y vlc"
    echo ""
    echo "Or for minimal installation:"
    echo "  sudo apt-get install -y vlc-nox"
fi

echo "=================================================="
echo ""

