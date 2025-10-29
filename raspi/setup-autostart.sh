#!/bin/bash
################################################################################
# Setup RTM TV2 Player Autostart on Raspberry Pi
# 
# This script configures the VLC player to start automatically on boot
# and remain on top of the queuescreen
################################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=============================================="
echo "  RTM TV2 Player - Autostart Setup"
echo -e "==============================================${NC}"
echo ""

# Get script directory (compatible with both bash and sh)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Autostart directory
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/rtm-player.desktop"

# Step 1: Create autostart directory if it doesn't exist
echo -e "${YELLOW}[1/4] Checking autostart directory...${NC}"
if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
    echo -e "${GREEN}✓ Created autostart directory${NC}"
else
    echo -e "${GREEN}✓ Autostart directory exists${NC}"
fi
echo ""

# Step 2: Make scripts executable
echo -e "${YELLOW}[2/4] Making scripts executable...${NC}"
chmod +x "$SCRIPT_DIR/play-rtm-quick.sh"
chmod +x "$SCRIPT_DIR/rtm-autostart.sh"
echo -e "${GREEN}✓ Scripts are now executable${NC}"
echo ""

# Step 3: Create desktop entry with correct path
echo -e "${YELLOW}[3/4] Creating autostart entry...${NC}"
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=RTM TV2 Player
Comment=Auto-start RTM TV2 VLC player on boot
Exec=$SCRIPT_DIR/rtm-autostart.sh
Icon=vlc
Terminal=false
Hidden=false
X-GNOME-Autostart-enabled=true
StartupNotify=false
EOF

if [ -f "$DESKTOP_FILE" ]; then
    echo -e "${GREEN}✓ Autostart entry created at:${NC}"
    echo "  $DESKTOP_FILE"
else
    echo -e "${RED}✗ Failed to create autostart entry${NC}"
    exit 1
fi
echo ""

# Step 4: Verify setup
echo -e "${YELLOW}[4/4] Verifying setup...${NC}"

if [ -x "$SCRIPT_DIR/play-rtm-quick.sh" ]; then
    echo -e "${GREEN}✓ play-rtm-quick.sh is executable${NC}"
else
    echo -e "${RED}✗ play-rtm-quick.sh is not executable${NC}"
fi

if [ -x "$SCRIPT_DIR/rtm-autostart.sh" ]; then
    echo -e "${GREEN}✓ rtm-autostart.sh is executable${NC}"
else
    echo -e "${RED}✗ rtm-autostart.sh is not executable${NC}"
fi

if [ -f "$DESKTOP_FILE" ]; then
    echo -e "${GREEN}✓ Desktop entry exists${NC}"
else
    echo -e "${RED}✗ Desktop entry missing${NC}"
fi

echo ""
echo -e "${BLUE}==============================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${BLUE}==============================================${NC}"
echo ""
echo "What happens on next reboot:"
echo "  1. Raspberry Pi boots up"
echo "  2. Desktop environment loads"
echo "  3. Queuescreen starts in browser (kiosk mode)"
echo "  4. After 15 seconds, VLC player starts on top"
echo ""
echo -e "${YELLOW}Important notes:${NC}"
echo "  • VLC will wait for network before starting"
echo "  • VLC will be positioned at ${VIDEO_WIDTH:-1670}x${VIDEO_HEIGHT:-930}"
echo "  • Logs are saved to: $SCRIPT_DIR/autostart.log"
echo ""
echo -e "${YELLOW}To test without rebooting:${NC}"
echo "  $SCRIPT_DIR/rtm-autostart.sh"
echo ""
echo -e "${YELLOW}To disable autostart:${NC}"
echo "  rm $DESKTOP_FILE"
echo ""
echo -e "${YELLOW}To manually start VLC:${NC}"
echo "  $SCRIPT_DIR/play-rtm-quick.sh"
echo ""
echo -e "${GREEN}Reboot your Raspberry Pi to activate autostart!${NC}"
echo ""

