#!/bin/bash
################################################################################
# RTM TV2 VLC Player - System Check & Diagnostics
# For Raspberry Pi with VLC 3.0.17
################################################################################

echo "=============================================="
echo "  RTM TV2 Player - System Diagnostics"
echo "=============================================="
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() {
    echo -e "${GREEN}✓ PASS${NC} - $1"
}

fail() {
    echo -e "${RED}✗ FAIL${NC} - $1"
}

warn() {
    echo -e "${YELLOW}⚠ WARN${NC} - $1"
}

info() {
    echo -e "  → $1"
}

echo "=== SYSTEM INFORMATION ==="
echo ""

# Check Raspberry Pi model
if [ -f /proc/device-tree/model ]; then
    MODEL=$(cat /proc/device-tree/model | tr -d '\0')
    pass "Raspberry Pi detected"
    info "Model: $MODEL"
else
    warn "Not running on Raspberry Pi?"
fi
echo ""

# Check OS
if [ -f /etc/os-release ]; then
    OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    pass "OS Information"
    info "$OS_NAME"
else
    warn "Cannot detect OS version"
fi
echo ""

echo "=== DEPENDENCIES ==="
echo ""

# Check Python3
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    pass "Python3 is installed"
    info "$PYTHON_VERSION"
else
    fail "Python3 is NOT installed"
    info "Install: sudo apt-get install python3"
fi
echo ""

# Check VLC
if command -v vlc &> /dev/null; then
    VLC_VERSION=$(vlc --version 2>&1 | head -n1)
    pass "VLC is installed"
    info "$VLC_VERSION"
    
    # Check if it's 3.0.17
    if echo "$VLC_VERSION" | grep -q "3.0.17"; then
        pass "VLC version 3.0.17 confirmed"
    else
        warn "VLC version is not 3.0.17"
        info "Scripts are optimized for 3.0.17"
    fi
else
    fail "VLC is NOT installed"
    info "Install: sudo apt-get install vlc"
fi
echo ""

# Check cvlc
if command -v cvlc &> /dev/null; then
    pass "cvlc (command-line VLC) available"
else
    warn "cvlc not found (usually comes with VLC)"
fi
echo ""

echo "=== SCRIPT FILES ==="
echo ""

# Check extractor script
if [ -f "$PARENT_DIR/extract-rtm-url.py" ]; then
    pass "Extractor script found"
    info "$PARENT_DIR/extract-rtm-url.py"
else
    fail "Extractor script NOT found"
    info "Expected: $PARENT_DIR/extract-rtm-url.py"
fi
echo ""

# Check player scripts
SCRIPTS=("play-rtm-quick.sh" "play-rtm-simple.sh" "extract-and-play-reliable.sh")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        if [ -x "$SCRIPT_DIR/$script" ]; then
            pass "$script (executable)"
        else
            warn "$script (not executable)"
            info "Fix: chmod +x $SCRIPT_DIR/$script"
        fi
    else
        fail "$script not found"
    fi
done
echo ""

echo "=== NETWORK CONNECTIVITY ==="
echo ""

# Check internet
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    pass "Internet connection OK"
else
    fail "No internet connection"
    info "Check your network settings"
fi
echo ""

# Check RTM website
if ping -c 1 -W 2 rtm.gov.my &> /dev/null; then
    pass "Can reach rtm.gov.my"
else
    warn "Cannot reach rtm.gov.my"
    info "May be temporary network issue"
fi
echo ""

echo "=== URL EXTRACTION TEST ==="
echo ""

# Test URL extraction
echo "Testing Python extractor..."
if python3 "$PARENT_DIR/extract-rtm-url.py" &> /tmp/extract_test.log; then
    pass "URL extraction successful"
    
    if [ -f "$PARENT_DIR/url.txt" ]; then
        URL=$(cat "$PARENT_DIR/url.txt")
        pass "URL file created"
        info "URL: $URL"
        
        # Test URL accessibility
        echo ""
        echo "Testing stream URL..."
        if curl -s --head --max-time 5 "$URL" | head -n1 | grep -q "200\|302\|301"; then
            pass "Stream URL is accessible"
        else
            warn "Stream URL may not be accessible"
            info "This could be temporary"
        fi
    else
        fail "URL file not created"
    fi
else
    fail "URL extraction failed"
    info "Check log: /tmp/extract_test.log"
fi
echo ""

echo "=== VLC PROCESSES ==="
echo ""

# Check running VLC
if pgrep -x "vlc" > /dev/null; then
    warn "VLC is currently running"
    info "PID(s): $(pgrep -x vlc | tr '\n' ' ')"
    info "Stop with: pkill vlc"
else
    pass "No VLC processes running"
fi
echo ""

echo "=== RECOMMENDATIONS ==="
echo ""

# Provide recommendations
ISSUES=0

if ! command -v python3 &> /dev/null; then
    echo "⚠ Install Python3: sudo apt-get install python3"
    ISSUES=$((ISSUES + 1))
fi

if ! command -v vlc &> /dev/null; then
    echo "⚠ Install VLC: sudo apt-get install vlc"
    ISSUES=$((ISSUES + 1))
fi

if [ ! -x "$SCRIPT_DIR/play-rtm-quick.sh" ]; then
    echo "⚠ Make scripts executable: chmod +x $SCRIPT_DIR/*.sh"
    ISSUES=$((ISSUES + 1))
fi

if ! ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    echo "⚠ Fix internet connection"
    ISSUES=$((ISSUES + 1))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! System is ready.${NC}"
    echo ""
    echo "Quick Start:"
    echo "  ./play-rtm-quick.sh"
else
    echo ""
    echo -e "${YELLOW}Found $ISSUES issue(s) that need attention.${NC}"
fi

echo ""
echo "=============================================="
echo "  Diagnostics Complete"
echo "=============================================="

