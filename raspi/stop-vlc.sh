#!/bin/bash
################################################################################
# Stop VLC Player
# Cleanly stops all VLC processes
################################################################################

echo "Stopping VLC..."

if pgrep -x "vlc" > /dev/null; then
    # Try graceful shutdown first
    pkill vlc 2>/dev/null
    sleep 2
    
    # Force kill if still running
    if pgrep -x "vlc" > /dev/null; then
        echo "Force stopping VLC..."
        pkill -9 vlc 2>/dev/null
        sleep 1
    fi
    
    # Verify stopped
    if pgrep -x "vlc" > /dev/null; then
        echo "✗ Failed to stop VLC"
        echo "  Try manually: sudo pkill -9 vlc"
        exit 1
    else
        echo "✓ VLC stopped successfully"
    fi
else
    echo "✓ VLC is not running"
fi

