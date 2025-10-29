#!/bin/bash
################################################################################
# RTM TV2 Player - Master Control Script
# Interactive menu for all player functions
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}       RTM TV2 Player for Raspberry Pi${NC}"
    echo -e "${BLUE}           VLC 3.0.17 Edition${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

show_menu() {
    echo -e "${CYAN}Select an option:${NC}"
    echo ""
    echo "  ${GREEN}[1]${NC} Play RTM TV2 (Quick)"
    echo "  ${GREEN}[2]${NC} Play RTM TV2 (Simple with feedback)"
    echo "  ${GREEN}[3]${NC} Play RTM TV2 (Reliable with auto-restart)"
    echo ""
    echo "  ${YELLOW}[4]${NC} Stop VLC Player"
    echo "  ${YELLOW}[5]${NC} Extract URL only (no playback)"
    echo "  ${YELLOW}[6]${NC} Show current stream URL"
    echo ""
    echo "  ${CYAN}[7]${NC} Test setup"
    echo "  ${CYAN}[8]${NC} System diagnostics"
    echo "  ${CYAN}[9]${NC} Install/Update dependencies"
    echo ""
    echo "  ${RED}[0]${NC} Exit"
    echo ""
    echo -n "Your choice: "
}

press_any_key() {
    echo ""
    echo -n "Press any key to continue..."
    read -n 1 -s
    echo ""
}

while true; do
    show_banner
    show_menu
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}Starting Quick Player...${NC}"
            echo ""
            "$SCRIPT_DIR/play-rtm-quick.sh"
            press_any_key
            ;;
        2)
            echo ""
            echo -e "${GREEN}Starting Simple Player...${NC}"
            echo ""
            "$SCRIPT_DIR/play-rtm-simple.sh"
            press_any_key
            ;;
        3)
            echo ""
            echo -e "${GREEN}Starting Reliable Player...${NC}"
            echo ""
            "$SCRIPT_DIR/extract-and-play-reliable.sh"
            press_any_key
            ;;
        4)
            echo ""
            echo -e "${YELLOW}Stopping VLC...${NC}"
            echo ""
            "$SCRIPT_DIR/stop-vlc.sh"
            press_any_key
            ;;
        5)
            echo ""
            echo -e "${YELLOW}Extracting URL...${NC}"
            echo ""
            PARENT_DIR="$(dirname "$SCRIPT_DIR")"
            python3 "$PARENT_DIR/extract-rtm-url.py"
            press_any_key
            ;;
        6)
            echo ""
            echo -e "${YELLOW}Current Stream URL:${NC}"
            PARENT_DIR="$(dirname "$SCRIPT_DIR")"
            if [ -f "$PARENT_DIR/url.txt" ]; then
                cat "$PARENT_DIR/url.txt"
            else
                echo "No URL file found. Extract URL first (option 5)."
            fi
            press_any_key
            ;;
        7)
            echo ""
            echo -e "${CYAN}Testing setup...${NC}"
            echo ""
            "$SCRIPT_DIR/test-setup.sh"
            press_any_key
            ;;
        8)
            echo ""
            echo -e "${CYAN}Running diagnostics...${NC}"
            echo ""
            "$SCRIPT_DIR/check-system.sh"
            press_any_key
            ;;
        9)
            echo ""
            echo -e "${CYAN}Installing/Updating...${NC}"
            echo ""
            "$SCRIPT_DIR/install.sh"
            press_any_key
            ;;
        0)
            echo ""
            echo -e "${GREEN}Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            sleep 2
            ;;
    esac
done

