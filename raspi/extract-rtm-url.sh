#!/bin/bash
# RTM TV2 URL Extractor - Raspberry Pi Version
# Primary method: Known working URL patterns

echo "=================================================="
echo "RTM TV2 URL Extractor for Raspberry Pi"
echo "=================================================="
echo ""

test_known_patterns() {
    echo "Testing known RTM URL patterns..."
    echo ""
    
    # Known RTM CDN patterns (in order of preference)
    patterns=(
        "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/playlist.m3u8"
        "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2"
        "https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/playlist.m3u8"
        "https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/chunklist_b2596000.m3u8"
    )
    
    count=1
    total=${#patterns[@]}
    
    for pattern in "${patterns[@]}"; do
        echo "[$count/$total] Testing: ${pattern:0:70}..."
        
        # Use curl to test URL
        if curl -s -I --max-time 5 -A "Mozilla/5.0 (X11; Linux armv7l)" "$pattern" | grep -q "200 OK"; then
            # Verify it's valid HLS content
            if curl -s --max-time 5 "$pattern" | head -c 100 | grep -q "EXTM3U"; then
                echo "      ✅ WORKING!"
                echo ""
                echo "$pattern"
                return 0
            fi
        fi
        
        echo "      ❌ Not working"
        ((count++))
    done
    
    echo ""
    echo "❌ No working URLs found"
    return 1
}

# Main execution
if url=$(test_known_patterns); then
    echo "=================================================="
    echo "✅ SUCCESS!"
    echo "=================================================="
    echo ""
    echo "Stream URL:"
    echo "  $url"
    echo ""
    
    # Save URL to file
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "$url" > "$script_dir/url.txt"
    
    echo "✓ URL saved to: $script_dir/url.txt"
    echo ""
    echo "You can now play with:"
    echo "  ./play-vlc.sh"
    echo "  or"
    echo "  cvlc $(cat $script_dir/url.txt)"
    echo ""
    exit 0
else
    echo "=================================================="
    echo "❌ FAILED"
    echo "=================================================="
    echo ""
    echo "Manual extraction required:"
    echo "1. Visit: https://rtmklik.rtm.gov.my/live/tv2"
    echo "2. Open DevTools (F12) → Network tab"
    echo "3. Filter by 'm3u8'"
    echo "4. Play the video and copy the .m3u8 URL"
    echo ""
    exit 1
fi

