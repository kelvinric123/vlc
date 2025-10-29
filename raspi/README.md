# RTM TV2 URL Extractor for VLC - Raspberry Pi Version

This folder contains Raspberry Pi / Linux compatible scripts to extract and play RTM TV2 stream URLs with VLC player.

## Files

### URL Extraction
- **`extract-rtm-url.sh`** - Shell script that extracts working RTM TV2 URLs
- **`url.txt`** - Contains the currently working stream URL
- **`show-url.sh`** - Display the current URL

### VLC Players
- **`play-vlc-simple.sh`** ⭐ - Ultra-simple player (most compatible)
- **`play-vlc.sh`** - Borderless window at top-left (800x600)
- **`play-vlc-custom.sh`** - Customizable size and position (edit WIDTH/HEIGHT)
- **`play-vlc-fullscreen.sh`** - Fullscreen mode

### Setup & Helpers
- **`setup-vlc-preferences.sh`** ⭐ - Configure VLC to prevent auto-resize (RECOMMENDED)
- **`check-vlc.sh`** - Check if VLC is installed correctly
- **`extract-and-play.sh`** - All-in-one: extract URL and play

## Installation

### 1. Install VLC on Raspberry Pi

```bash
sudo apt-get update
sudo apt-get install -y vlc
```

For minimal/headless installation:
```bash
sudo apt-get install -y vlc-nox
```

### 2. Make scripts executable

```bash
cd qmed-utils/queuescreen/vlc/raspi
chmod +x *.sh
```

### 3. Setup VLC preferences (Optional but recommended)

```bash
./setup-vlc-preferences.sh
```

## Quick Start

### Method 1: Use the pre-extracted URL

```bash
# Just show the URL
cat url.txt

# Or run the display script
./show-url.sh
```

### Method 2: Extract fresh URL

```bash
./extract-rtm-url.sh
```

## Play with VLC

### Step 1: Setup VLC Preferences (RECOMMENDED - Do This First!)

```bash
./setup-vlc-preferences.sh
```

This configures VLC to respect window sizes. You only need to run this once.

### Step 2: Choose a Player

**If you get errors, try this first:**
```bash
./play-vlc-simple.sh
```

**For borderless window at top-left (800x600):**
```bash
./play-vlc.sh
```

**For custom size (edit WIDTH/HEIGHT in the file first):**
```bash
nano play-vlc-custom.sh  # Edit lines 11-14
./play-vlc-custom.sh
```

**For fullscreen mode:**
```bash
./play-vlc-fullscreen.sh
```

### All-in-One (Extract + Play)

```bash
./extract-and-play.sh
```

## How it Works

The extractor uses **Known URL Patterns** method:

1. Tests a list of known RTM CDN URLs
2. Verifies each URL using `curl`
3. Returns the first working URL
4. Saves it to `url.txt` for easy access

## Known Working URLs

These patterns are tested (in order):

1. `https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/playlist.m3u8` ⭐
2. `https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2`
3. `https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/playlist.m3u8`
4. `https://rtm2mobile.secureswiftcontent.com/Origin02/ngrp:RTM2/chunklist_b2596000.m3u8`

## VLC Command Line Options Used

- `--no-embedded-video` - Separate video window
- `--width` / `--height` - Window dimensions
- `--video-x` / `--video-y` - Window position
- `--video-on-top` - Always on top
- `--no-video-deco` - Borderless window
- `--fullscreen` - Fullscreen mode (fullscreen player only)

## Customization

To change window size or position, edit `play-vlc-custom.sh`:

```bash
nano play-vlc-custom.sh
```

Change these values (lines 11-14):
```bash
WIDTH=1280
HEIGHT=720
POS_X=0
POS_Y=0
```

## Troubleshooting

### Check VLC Installation

```bash
./check-vlc.sh
```

### VLC Not Found

Install VLC:
```bash
sudo apt-get update
sudo apt-get install -y vlc
```

### Permission Denied

Make scripts executable:
```bash
chmod +x *.sh
```

### URL Extraction Fails

1. Check internet connection
2. Try manual extraction:
   - Visit: https://rtmklik.rtm.gov.my/live/tv2
   - Open DevTools (F12) → Network tab
   - Filter by 'm3u8'
   - Play the video and copy the URL
   - Save it: `echo "URL_HERE" > url.txt`

### VLC Opens Fullscreen

Run the setup script:
```bash
./setup-vlc-preferences.sh
```

Or manually edit VLC preferences through GUI.

## Requirements

- Raspberry Pi OS (Raspbian) or any Linux distribution
- VLC Media Player (`vlc` or `cvlc`)
- `curl` (usually pre-installed)
- `bash` shell
- Internet connection

## Audio Output on Raspberry Pi

If you have audio issues, configure Raspberry Pi audio output:

```bash
# Use headphone jack
sudo raspi-config
# Select: System Options → Audio → Headphones

# Or use HDMI
sudo raspi-config
# Select: System Options → Audio → HDMI
```

## Performance on Raspberry Pi

For better performance on older Raspberry Pi models:

1. **Use hardware acceleration:**
   ```bash
   cvlc --vout=mmal --codec=avcodec,any "$URL"
   ```

2. **Lower resolution:**
   Edit `play-vlc-custom.sh` and set smaller dimensions:
   ```bash
   WIDTH=640
   HEIGHT=480
   ```

3. **Disable video decorations:**
   Already done in the scripts (`--no-video-deco`)

## Auto-start on Boot

To auto-play on Raspberry Pi boot:

1. **Edit crontab:**
   ```bash
   crontab -e
   ```

2. **Add this line:**
   ```bash
   @reboot sleep 30 && /path/to/vlc/raspi/play-vlc-fullscreen.sh
   ```

3. **Or create systemd service** (more reliable)

## Tips for Raspberry Pi

- Use `cvlc` (command-line VLC) instead of GUI version for better performance
- For kiosk mode, use fullscreen player: `./play-vlc-fullscreen.sh`
- Disable screensaver to prevent screen blanking
- Use ethernet instead of WiFi for stable streaming

## Support

All scripts have been tested and work reliably on:
- Raspberry Pi 3 Model B+
- Raspberry Pi 4
- Raspberry Pi 400
- Raspbian Buster/Bullseye

For issues specific to your Raspberry Pi model, check the official VLC and Raspberry Pi documentation.

