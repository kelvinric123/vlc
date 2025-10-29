# RTM TV2 URL Extractor for VLC

This folder contains tools to extract and use RTM TV2 stream URLs with VLC player.

## Files

### URL Extraction
- **`extract-rtm-url.py`** - Python script that extracts working RTM TV2 URLs
- **`url.txt`** - Contains the currently working stream URL
- **`run-extractor.bat`** - Windows batch file to run the extractor
- **`show-url.bat`** - Windows batch file to display the current URL

### VLC Players
- **`play-vlc-simple.bat`** ⭐ - Ultra-simple player (most compatible, no size control)
- **`play-vlc.bat`** - Borderless window at top-left (800x600)
- **`play-vlc-custom.bat`** - Customizable size and position (edit WIDTH/HEIGHT)
- **`play-vlc-small.bat`** - Small 640x480 window
- **`play-vlc.py`** - Python version of the VLC player

### Setup & Helpers
- **`setup-vlc-preferences.bat`** ⭐ - Configure VLC to prevent auto-resize (RECOMMENDED)
- **`check-vlc.bat`** - Check if VLC is installed correctly
- **`extract-and-play.bat`** - All-in-one: extract URL and play

## Quick Start

### Method 1: Use the pre-extracted URL

```bash
# Just show the URL
type url.txt

# Or run the batch file
show-url.bat
```

### Method 2: Extract fresh URL

```bash
# Run the Python script directly
python extract-rtm-url.py

# Or use the batch file
run-extractor.bat
```

## Play with VLC

### Step 1: Setup VLC Preferences (IMPORTANT - Do This First!)

To prevent VLC from auto-resizing to fullscreen:
```bash
setup-vlc-preferences.bat
```

This configures VLC to respect window sizes. You only need to run this once.

### Step 2: Choose a Player

**If you get "invalid options" error, try this first:**
```bash
play-vlc-simple.bat
```

**For borderless window at top-left (800x600):**
```bash
play-vlc.bat
```

**For custom size (edit WIDTH/HEIGHT in the file first):**
```bash
play-vlc-custom.bat
```

**For small test window (640x480):**
```bash
play-vlc-small.bat
```

### Option 2: Manual VLC Command

```bash
# Windows - Basic
vlc "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2"

# Or use the URL from file
for /f "delims=" %i in (url.txt) do vlc "%i"
```

## How it Works

The extractor uses **Method 5: Known URL Patterns** as the primary method:

1. Tests a list of known RTM CDN URLs
2. Verifies each URL by connecting and checking for valid HLS content
3. Returns the first working URL
4. Saves it to `url.txt` for easy access

## Known Working URLs

These are the patterns tested (in order):

1. `https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/playlist.m3u8` ⭐
2. `https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2`
3. `https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/playlist.m3u8`
4. `https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/chunklist_b2596000.m3u8`

## Troubleshooting

If the extractor fails:

1. The URLs might have changed
2. Check your internet connection
3. Try manual extraction:
   - Visit: https://rtmklik.rtm.gov.my/live/tv2
   - Press F12 → Network tab
   - Filter by 'm3u8'
   - Play the video and copy the URL
   - Paste it into `url.txt`

## VLC Player Features

The player scripts automatically configure VLC with:
- ✅ **Borderless window** - No title bar or borders
- ✅ **Always on top** - Stays above other windows
- ✅ **Top-left position** - Anchored at (0, 0)
- ✅ **No title overlay** - Clean viewing experience
- ✅ **Auto-read URL** - Gets URL from `url.txt` automatically

### Customization

To change window size or position, edit `play-vlc-custom.bat`:
```batch
set WIDTH=1280
set HEIGHT=720
set POS_X=0
set POS_Y=0
```

### VLC Command Line Options Used

- `--video-on-top` - Keep window always on top
- `--no-video-deco` - Remove window decorations (borderless)
- `--no-embedded-video` - Use separate video window
- `--video-x=0 --video-y=0` - Position at top-left
- `--width=800 --height=600` - Window size
- `--no-video-title-show` - Hide title overlay
- `--no-osd` - No on-screen display

## Requirements

- Python 3.x
- VLC Media Player (for playback)
- Internet connection

### Installing VLC

**Download VLC:**
- Visit: https://www.videolan.org/vlc/
- Download and install the Windows version
- Default installation path: `C:\Program Files\VideoLAN\VLC\`

**Check if VLC is installed:**
```bash
check-vlc.bat
```

The scripts will automatically find VLC in these locations:
- `C:\Program Files\VideoLAN\VLC\vlc.exe` ✓
- `C:\Program Files (x86)\VideoLAN\VLC\vlc.exe` ✓
- System PATH (if added) ✓

