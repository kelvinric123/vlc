#!/bin/bash
# Setup VLC Preferences on Raspberry Pi
# This modifies VLC's config file to prevent auto-resize

echo "=================================================="
echo "VLC Preferences Setup (Raspberry Pi)"
echo "=================================================="
echo ""
echo "This will configure VLC to NOT auto-resize windows"
echo ""

# VLC config directory on Linux
VLC_CONFIG_DIR="$HOME/.config/vlc"

# Create config directory if it doesn't exist
if [ ! -d "$VLC_CONFIG_DIR" ]; then
    echo "Creating VLC config directory..."
    mkdir -p "$VLC_CONFIG_DIR"
fi

echo "VLC Config Directory: $VLC_CONFIG_DIR"
echo ""

# Backup existing vlcrc if it exists
if [ -f "$VLC_CONFIG_DIR/vlcrc" ]; then
    echo "Backing up existing vlcrc..."
    cp "$VLC_CONFIG_DIR/vlcrc" "$VLC_CONFIG_DIR/vlcrc.backup"
    echo "Backup saved: vlcrc.backup"
    echo ""
fi

echo "Writing VLC preferences..."
echo ""

# Create/update vlcrc with our settings
cat > "$VLC_CONFIG_DIR/vlcrc" << 'EOF'
# VLC Preferences - Modified by RTM TV2 VLC scripts
# Disable auto-resize to prevent fullscreen issues

[qt]
qt-video-autoresize=0

[core]
no-autoscale=1
video-on-top=1
no-video-deco=1
EOF

echo "=================================================="
echo "SUCCESS!"
echo "=================================================="
echo ""
echo "VLC preferences have been configured:"
echo "  - Auto-resize: DISABLED"
echo "  - Auto-scale: DISABLED"
echo "  - Always on top: ENABLED"
echo "  - No decorations: ENABLED"
echo ""
echo "Config file: $VLC_CONFIG_DIR/vlcrc"
echo ""
echo "Now try running:"
echo "  ./play-vlc-custom.sh"
echo ""
echo "VLC should now respect the window size!"
echo "=================================================="
echo ""

