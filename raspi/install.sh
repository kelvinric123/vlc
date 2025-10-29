#!/bin/bash
# One-command installation script for RTM TV2 VLC Player on Raspberry Pi

echo "=================================================="
echo "RTM TV2 VLC Player - Raspberry Pi Installer"
echo "=================================================="
echo ""

echo "This script will:"
echo "  1. Install VLC Media Player"
echo "  2. Make all scripts executable"
echo "  3. Setup VLC preferences"
echo "  4. Test the installation"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 1
fi

echo ""
echo "=================================================="
echo "Step 1: Installing VLC..."
echo "=================================================="
echo ""

if command -v cvlc &> /dev/null; then
    echo "✓ VLC is already installed!"
else
    echo "Installing VLC Media Player..."
    sudo apt-get update
    sudo apt-get install -y vlc
    
    if [ $? -eq 0 ]; then
        echo "✓ VLC installed successfully!"
    else
        echo "✗ Failed to install VLC"
        echo "Please run: sudo apt-get install -y vlc"
        exit 1
    fi
fi

echo ""
echo "=================================================="
echo "Step 2: Making scripts executable..."
echo "=================================================="
echo ""

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
chmod +x "$script_dir"/*.sh

if [ $? -eq 0 ]; then
    echo "✓ All scripts are now executable!"
else
    echo "✗ Failed to make scripts executable"
    exit 1
fi

echo ""
echo "=================================================="
echo "Step 3: Setting up VLC preferences..."
echo "=================================================="
echo ""

"$script_dir/setup-vlc-preferences.sh"

echo ""
echo "=================================================="
echo "Step 4: Testing installation..."
echo "=================================================="
echo ""

"$script_dir/check-vlc.sh"

echo ""
echo "=================================================="
echo "🎉 INSTALLATION COMPLETE!"
echo "=================================================="
echo ""
echo "Quick Start:"
echo ""
echo "  1. Extract URL:"
echo "     ./extract-rtm-url.sh"
echo ""
echo "  2. Play with VLC:"
echo "     ./play-vlc-simple.sh"
echo ""
echo "  3. Or use custom size:"
echo "     nano play-vlc-custom.sh  # Edit WIDTH/HEIGHT"
echo "     ./play-vlc-custom.sh"
echo ""
echo "  4. Or all-in-one:"
echo "     ./extract-and-play.sh"
echo ""
echo "For detailed instructions, read:"
echo "  cat QUICK-START.md"
echo ""
echo "=================================================="
echo ""

