#!/bin/bash
################################################################################
# RTM TV2 VLC Player - Installation Script for Raspberry Pi
################################################################################

echo "=============================================="
echo "  RTM TV2 VLC Player - Installation"
echo "=============================================="
echo ""

# Check if running on Raspberry Pi
if [ -f /proc/device-tree/model ]; then
    MODEL=$(cat /proc/device-tree/model)
    echo "Detected: $MODEL"
else
    echo "Warning: May not be running on Raspberry Pi"
fi
echo ""

# Update package list
echo "[1/4] Updating package list..."
sudo apt-get update -qq

# Install VLC
echo "[2/4] Checking VLC installation..."
if command -v vlc &> /dev/null; then
    VLC_VERSION=$(vlc --version | head -n1)
    echo "✓ VLC already installed: $VLC_VERSION"
else
    echo "Installing VLC..."
    sudo apt-get install -y vlc
    echo "✓ VLC installed"
fi
echo ""

# Check Python3
echo "[3/4] Checking Python3..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ Python3 is installed: $PYTHON_VERSION"
else
    echo "Installing Python3..."
    sudo apt-get install -y python3
    echo "✓ Python3 installed"
fi
echo ""

# Make scripts executable
echo "[4/4] Making scripts executable..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$SCRIPT_DIR"/*.sh
echo "✓ All scripts are now executable"
echo ""

# Test extraction
echo "=============================================="
echo "Testing URL extraction..."
echo "=============================================="
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
python3 "$PARENT_DIR/extract-rtm-url.py"

if [ $? -eq 0 ]; then
    echo ""
    echo "=============================================="
    echo "✓ Installation Complete!"
    echo "=============================================="
    echo ""
    echo "Quick Start:"
    echo "  cd $SCRIPT_DIR"
    echo "  ./play-rtm-quick.sh"
    echo ""
    echo "Or for reliable playback with auto-restart:"
    echo "  ./extract-and-play-reliable.sh"
    echo ""
    echo "See README.md for more options"
else
    echo ""
    echo "=============================================="
    echo "⚠ Installation complete but URL extraction failed"
    echo "=============================================="
    echo ""
    echo "This may be due to network issues."
    echo "Try running the player scripts anyway:"
    echo "  ./play-rtm-quick.sh"
fi

