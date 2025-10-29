#!/usr/bin/env python3
"""
RTM TV2 VLC Player
Plays the stream in borderless mode, always on top, positioned at top-left
"""

import sys
import subprocess
from pathlib import Path

def print_header():
    print("=" * 50)
    print("RTM TV2 VLC Player")
    print("=" * 50)
    print()

def get_stream_url():
    """Read stream URL from url.txt"""
    script_dir = Path(__file__).parent
    url_file = script_dir / 'url.txt'
    
    if not url_file.exists():
        print("❌ Error: url.txt not found!")
        print("Please run extract-rtm-url.py first")
        return None
    
    try:
        url = url_file.read_text().strip()
        if not url:
            print("❌ Error: url.txt is empty!")
            return None
        return url
    except Exception as e:
        print(f"❌ Error reading url.txt: {e}")
        return None

def play_vlc(url):
    """Launch VLC with borderless, always-on-top settings"""
    print(f"Stream URL: {url}")
    print()
    print("Starting VLC with:")
    print("  ✓ Borderless window")
    print("  ✓ Always on top")
    print("  ✓ Position: Top-Left (0, 0)")
    print("  ✓ Size: 800x600")
    print()
    
    # VLC command with special parameters
    vlc_args = [
        'vlc',
        url,
        '--video-on-top',           # Always on top
        '--no-video-deco',          # No window decoration (borderless)
        '--no-embedded-video',      # Separate video window
        '--video-x=0',              # X position (left)
        '--video-y=0',              # Y position (top)
        '--width=800',              # Window width
        '--height=600',             # Window height
        '--no-video-title-show',    # Don't show title overlay
        '--no-osd',                 # No on-screen display
    ]
    
    try:
        print("Launching VLC...")
        print()
        
        # Try to launch VLC
        subprocess.run(vlc_args)
        
        print()
        print("VLC closed.")
        return 0
        
    except FileNotFoundError:
        print("❌ Error: VLC not found in PATH")
        print()
        print("Please either:")
        print("  1. Add VLC to your PATH")
        print("  2. Or use the batch file: play-vlc.bat")
        print()
        return 1
    except Exception as e:
        print(f"❌ Error launching VLC: {e}")
        return 1

def main():
    print_header()
    
    # Get stream URL
    url = get_stream_url()
    if not url:
        return 1
    
    # Play with VLC
    return play_vlc(url)

if __name__ == '__main__':
    sys.exit(main())

