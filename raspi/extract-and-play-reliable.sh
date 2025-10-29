#!/bin/bash
################################################################################
# RTM TV2 Reliable Extractor & VLC Player for Raspberry Pi (Queue Screen)
# VLC Version: 3.0.17
# 
# This script:
# 1. Extracts the working RTM TV2 stream URL using Python
# 2. Launches VLC with optimal flags and CUSTOM DIMENSIONS for queue screen
# 3. Auto-restarts on stream failure
#
# QUEUE SCREEN MODE:
# - VLC is positioned and sized to fit within your queue screen layout
# - Video area excludes the right panel (date/time) and bottom bar (branding)
# - Default: 1670x930 pixels at position (0,0) for 1920x1080 screen
#
# TO ADJUST DIMENSIONS:
# 1. Measure your video display area (exclude UI panels)
# 2. Edit VIDEO_WIDTH, VIDEO_HEIGHT, VIDEO_X, VIDEO_Y below
# 3. Test and adjust until VLC fits perfectly
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
URL_FILE="$PARENT_DIR/url.txt"
EXTRACTOR_SCRIPT="$PARENT_DIR/extract-rtm-url.py"
LOG_FILE="$SCRIPT_DIR/playback.log"
MAX_RETRIES=3
RETRY_DELAY=5

# Queue Screen Video Dimensions (measured from queuescreen layout)
# 
# MEASUREMENT GUIDE:
# - Total screen: 1920x1080 (standard HD)
# - Right panel width: ~250px (date/time display)
# - Bottom bar height: ~150px (branding area)
# - Video area: Screen width - right panel, Screen height - bottom bar
#
# CURRENT SETTINGS (for 1920x1080 screen):
VIDEO_WIDTH=1670    # 1920 - 250 = 1670 (leaves space for right panel)
VIDEO_HEIGHT=930    # 1080 - 150 = 930 (leaves space for bottom bar)
VIDEO_X=0           # X position (left edge of screen)
VIDEO_Y=0           # Y position (top edge of screen)

################################################################################
# Functions
################################################################################

log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} - ${message}" | tee -a "$LOG_FILE"
}

print_banner() {
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${BLUE}   RTM TV2 Reliable Player for Raspberry Pi (VLC 3.0.17)${NC}"
    echo -e "${BLUE}================================================================${NC}"
    echo ""
}

check_dependencies() {
    log_message "${YELLOW}Checking dependencies...${NC}"
    
    # Check for Python3
    if ! command -v python3 &> /dev/null; then
        log_message "${RED}ERROR: python3 is not installed${NC}"
        exit 1
    fi
    log_message "${GREEN}✓ Python3 found: $(python3 --version)${NC}"
    
    # Check for VLC
    if ! command -v cvlc &> /dev/null && ! command -v vlc &> /dev/null; then
        log_message "${RED}ERROR: VLC is not installed${NC}"
        log_message "Install with: sudo apt-get install vlc"
        exit 1
    fi
    
    if command -v cvlc &> /dev/null; then
        VLC_CMD="cvlc"
        log_message "${GREEN}✓ VLC found: $(cvlc --version | head -n1)${NC}"
    else
        VLC_CMD="vlc"
        log_message "${GREEN}✓ VLC found: $(vlc --version | head -n1)${NC}"
    fi
    
    # Check for extractor script
    if [ ! -f "$EXTRACTOR_SCRIPT" ]; then
        log_message "${RED}ERROR: Extractor script not found at: $EXTRACTOR_SCRIPT${NC}"
        exit 1
    fi
    log_message "${GREEN}✓ Extractor script found${NC}"
    
    echo ""
}

extract_url() {
    log_message "${YELLOW}Extracting stream URL...${NC}"
    
    # Run the Python extractor
    if python3 "$EXTRACTOR_SCRIPT" > /tmp/extract_output.log 2>&1; then
        if [ -f "$URL_FILE" ] && [ -s "$URL_FILE" ]; then
            STREAM_URL=$(cat "$URL_FILE")
            log_message "${GREEN}✓ Stream URL extracted successfully${NC}"
            log_message "${GREEN}  URL: $STREAM_URL${NC}"
            echo ""
            return 0
        else
            log_message "${RED}ERROR: URL file is empty or not created${NC}"
            return 1
        fi
    else
        log_message "${RED}ERROR: Failed to extract stream URL${NC}"
        cat /tmp/extract_output.log | tee -a "$LOG_FILE"
        return 1
    fi
}

kill_existing_vlc() {
    log_message "${YELLOW}Checking for existing VLC processes...${NC}"
    
    if pgrep -x "vlc" > /dev/null; then
        log_message "${YELLOW}Killing existing VLC processes...${NC}"
        pkill -9 vlc 2>/dev/null || true
        sleep 2
        log_message "${GREEN}✓ Existing VLC processes terminated${NC}"
    else
        log_message "${GREEN}✓ No existing VLC processes found${NC}"
    fi
    echo ""
}

play_stream() {
    local url="$1"
    
    log_message "${YELLOW}Starting VLC playback...${NC}"
    log_message "Stream URL: $url"
    log_message "${BLUE}Video dimensions: ${VIDEO_WIDTH}x${VIDEO_HEIGHT} at position (${VIDEO_X},${VIDEO_Y})${NC}"
    echo ""
    
    # VLC options optimized for Raspberry Pi 3.0.17 with custom dimensions
    # Positioned and sized to fit queue screen layout
    $VLC_CMD \
        --width=$VIDEO_WIDTH \
        --height=$VIDEO_HEIGHT \
        --video-x=$VIDEO_X \
        --video-y=$VIDEO_Y \
        --no-video-title-show \
        --no-video-deco \
        --no-embedded-video \
        --no-osd \
        --quiet \
        --network-caching=2000 \
        --live-caching=2000 \
        --clock-jitter=0 \
        --clock-synchro=0 \
        --file-caching=2000 \
        --no-audio-time-stretch \
        --prefer-insecure \
        --http-reconnect \
        --adaptive-logic=highest \
        --adaptive-maxwidth=1920 \
        --adaptive-maxheight=1080 \
        --loop \
        "$url" \
        >> "$LOG_FILE" 2>&1 &
    
    VLC_PID=$!
    log_message "${GREEN}✓ VLC started (PID: $VLC_PID)${NC}"
    log_message "${GREEN}✓ Playing at ${VIDEO_WIDTH}x${VIDEO_HEIGHT} (positioned for queue screen)${NC}"
    echo ""
    
    # Monitor VLC process
    sleep 3
    if ps -p $VLC_PID > /dev/null; then
        log_message "${GREEN}✓ VLC is running successfully${NC}"
        return 0
    else
        log_message "${RED}ERROR: VLC process died immediately${NC}"
        return 1
    fi
}

monitor_playback() {
    log_message "${BLUE}Monitoring playback... (Press Ctrl+C to stop)${NC}"
    echo ""
    
    while true; do
        if ! pgrep -x "vlc" > /dev/null; then
            log_message "${YELLOW}VLC process ended. Restarting...${NC}"
            return 1
        fi
        sleep 10
    done
}

main_loop() {
    local retry_count=0
    
    while [ $retry_count -lt $MAX_RETRIES ]; do
        log_message "${BLUE}=== Attempt $(($retry_count + 1)) of $MAX_RETRIES ===${NC}"
        
        # Extract URL
        if ! extract_url; then
            retry_count=$(($retry_count + 1))
            if [ $retry_count -lt $MAX_RETRIES ]; then
                log_message "${YELLOW}Retrying in $RETRY_DELAY seconds...${NC}"
                sleep $RETRY_DELAY
            fi
            continue
        fi
        
        # Kill any existing VLC
        kill_existing_vlc
        
        # Play stream
        if play_stream "$STREAM_URL"; then
            # Monitor playback
            if monitor_playback; then
                log_message "${GREEN}Playback ended normally${NC}"
                return 0
            else
                log_message "${YELLOW}Playback interrupted. Restarting...${NC}"
                retry_count=0  # Reset retry count for playback issues
                sleep $RETRY_DELAY
            fi
        else
            retry_count=$(($retry_count + 1))
            if [ $retry_count -lt $MAX_RETRIES ]; then
                log_message "${YELLOW}Retrying in $RETRY_DELAY seconds...${NC}"
                sleep $RETRY_DELAY
            fi
        fi
    done
    
    log_message "${RED}Maximum retries reached. Exiting.${NC}"
    return 1
}

cleanup() {
    log_message "${YELLOW}Cleaning up...${NC}"
    pkill -9 vlc 2>/dev/null || true
    log_message "${GREEN}Done.${NC}"
}

################################################################################
# Main Execution
################################################################################

# Trap Ctrl+C and cleanup
trap cleanup EXIT INT TERM

print_banner
log_message "${GREEN}Starting RTM TV2 Player...${NC}"
echo ""

check_dependencies
main_loop

exit $?

