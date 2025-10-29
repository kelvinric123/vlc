#!/bin/bash
################################################################################
# Setup Script - Make all scripts executable
# Run this once after copying files to Raspberry Pi
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=============================================="
echo "  Setting up file permissions..."
echo "=============================================="
echo ""

chmod +x "$SCRIPT_DIR"/*.sh

if [ $? -eq 0 ]; then
    echo "✓ All shell scripts are now executable"
    echo ""
    echo "Available scripts:"
    ls -lh "$SCRIPT_DIR"/*.sh | awk '{print "  " $9}' | sed "s|$SCRIPT_DIR/||g"
    echo ""
    echo "Quick Start:"
    echo "  ./rtm-player.sh         (Interactive menu)"
    echo "  ./play-rtm-quick.sh     (Start playing immediately)"
    echo "  ./test-setup.sh         (Test your setup)"
    echo ""
else
    echo "✗ Failed to set permissions"
    echo "Try manually: chmod +x *.sh"
    exit 1
fi

