#!/bin/bash
################################################################################
# Test Script - Verify everything is working
# This does NOT start VLC, just tests components
################################################################################

echo "=============================================="
echo "  RTM TV2 Player - Setup Test"
echo "=============================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

SUCCESS=0
FAILED=0

test_step() {
    echo -n "Testing: $1... "
}

test_pass() {
    echo "✓ PASS"
    SUCCESS=$((SUCCESS + 1))
}

test_fail() {
    echo "✗ FAIL: $1"
    FAILED=$((FAILED + 1))
}

# Test 1: Python3
test_step "Python3 installation"
if command -v python3 &> /dev/null; then
    test_pass
else
    test_fail "Python3 not found"
fi

# Test 2: VLC
test_step "VLC installation"
if command -v vlc &> /dev/null || command -v cvlc &> /dev/null; then
    test_pass
else
    test_fail "VLC not found"
fi

# Test 3: Extractor script
test_step "Extractor script exists"
if [ -f "$PARENT_DIR/extract-rtm-url.py" ]; then
    test_pass
else
    test_fail "extract-rtm-url.py not found"
fi

# Test 4: Scripts executable
test_step "Scripts are executable"
if [ -x "$SCRIPT_DIR/play-rtm-quick.sh" ]; then
    test_pass
else
    test_fail "Scripts not executable (run: chmod +x *.sh)"
fi

# Test 5: Internet
test_step "Internet connectivity"
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    test_pass
else
    test_fail "No internet connection"
fi

# Test 6: URL Extraction
test_step "URL extraction"
if python3 "$PARENT_DIR/extract-rtm-url.py" &> /tmp/test_extract.log; then
    if [ -f "$PARENT_DIR/url.txt" ] && [ -s "$PARENT_DIR/url.txt" ]; then
        test_pass
        URL=$(cat "$PARENT_DIR/url.txt")
        echo "  → Stream URL: ${URL:0:60}..."
    else
        test_fail "URL file not created or empty"
    fi
else
    test_fail "Extraction failed (check /tmp/test_extract.log)"
fi

echo ""
echo "=============================================="
echo "  Test Results"
echo "=============================================="
echo "Passed: $SUCCESS"
echo "Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✓ ALL TESTS PASSED!"
    echo ""
    echo "You're ready to play:"
    echo "  ./play-rtm-quick.sh"
    echo ""
    exit 0
else
    echo "✗ SOME TESTS FAILED"
    echo ""
    echo "Run diagnostics for details:"
    echo "  ./check-system.sh"
    echo ""
    exit 1
fi

