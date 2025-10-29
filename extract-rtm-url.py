#!/usr/bin/env python3
"""
RTM TV2 URL Extractor - VLC Version
Primary method: Known working URL patterns
"""

import sys
import urllib.request
import urllib.error
from pathlib import Path

def print_header():
    print("=" * 50)
    print("RTM TV2 URL Extractor for VLC")
    print("=" * 50)
    print()

def test_known_patterns():
    """Test known RTM URL patterns - Primary Method"""
    print("Testing known RTM URL patterns...")
    print()
    
    # Known RTM CDN patterns (in order of preference)
    patterns = [
        "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/playlist.m3u8",
        "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2",
        "https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/playlist.m3u8",
        "https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/chunklist_b2596000.m3u8",
    ]
    
    for i, pattern in enumerate(patterns, 1):
        print(f"[{i}/{len(patterns)}] Testing: {pattern[:70]}...")
        try:
            req = urllib.request.Request(pattern)
            req.add_header('User-Agent', 'Mozilla/5.0 (X11; Linux armv7l) AppleWebKit/537.36')
            
            with urllib.request.urlopen(req, timeout=5) as response:
                if response.status == 200:
                    # Read a bit to verify it's valid
                    content = response.read(100)
                    if b'#EXTM3U' in content or b'.ts' in content:
                        print(f"      ✅ WORKING!")
                        print()
                        return pattern
                    
        except urllib.error.HTTPError as e:
            print(f"      ❌ HTTP Error {e.code}")
        except urllib.error.URLError as e:
            print(f"      ❌ Connection failed: {e.reason}")
        except Exception as e:
            print(f"      ❌ Error: {e}")
    
    print()
    print("❌ No working URLs found")
    return None

def save_url(url):
    """Save URL to file"""
    script_dir = Path(__file__).parent
    url_file = script_dir / 'url.txt'
    
    try:
        url_file.write_text(url)
        print(f"✓ URL saved to: {url_file}")
        return True
    except Exception as e:
        print(f"✗ Error saving URL: {e}")
        return False

def main():
    print_header()
    
    # Test known patterns (Primary method)
    url = test_known_patterns()
    
    if url:
        print("=" * 50)
        print("✅ SUCCESS!")
        print("=" * 50)
        print()
        print(f"Stream URL:")
        print(f"  {url}")
        print()
        
        if save_url(url):
            print()
            print("You can now play with VLC:")
            print(f"  vlc {url}")
            print()
            print("Or read from file:")
            print(f"  vlc $(cat {Path(__file__).parent / 'url.txt'})")
            print()
        
        return 0
    else:
        print("=" * 50)
        print("❌ FAILED")
        print("=" * 50)
        print()
        print("Manual extraction required:")
        print("1. Visit: https://rtmklik.rtm.gov.my/live/tv2")
        print("2. Open DevTools (F12) → Network tab")
        print("3. Filter by 'm3u8'")
        print("4. Play the video and copy the .m3u8 URL")
        print()
        return 1

if __name__ == '__main__':
    sys.exit(main())

