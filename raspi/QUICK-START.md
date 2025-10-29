# Quick Start Guide - RTM TV2 VLC Player (Raspberry Pi)

## The Right Way to Start (Step by Step)

### 1️⃣ First Time Setup

**Step A: Install VLC**
```bash
sudo apt-get update
sudo apt-get install -y vlc
```

**Step B: Make scripts executable**
```bash
cd ~/qmed-utils/queuescreen/vlc/raspi
chmod +x *.sh
```

**Step C: Check VLC installation**
```bash
./check-vlc.sh
```

**Step D: Configure VLC preferences**
```bash
./setup-vlc-preferences.sh
```

This prevents VLC from auto-resizing. ⭐ **IMPORTANT!**

### 2️⃣ Test VLC (Simple Mode)

```bash
./play-vlc-simple.sh
```

This uses the most basic VLC options. If this works, you're good to go!

### 3️⃣ Try Custom Size

Edit the custom player:
```bash
nano play-vlc-custom.sh
```

Change these lines (around line 11-14):
```bash
WIDTH=640
HEIGHT=480
POS_X=0
POS_Y=0
```

Save (`Ctrl+O`, `Enter`) and exit (`Ctrl+X`), then run:
```bash
./play-vlc-custom.sh
```

### 4️⃣ For Fullscreen (Kiosk Mode)

```bash
./play-vlc-fullscreen.sh
```

Perfect for digital signage or display screens!

## Quick Commands Reference

```bash
# Check VLC installation
./check-vlc.sh

# Extract fresh URL
./extract-rtm-url.sh

# Show current URL
./show-url.sh

# Play - simple mode
./play-vlc-simple.sh

# Play - custom size
./play-vlc-custom.sh

# Play - fullscreen
./play-vlc-fullscreen.sh

# All-in-one (extract + play)
./extract-and-play.sh
```

## Troubleshooting

### Problem: "Permission denied"

**Solution:** Make scripts executable
```bash
chmod +x *.sh
```

### Problem: "VLC not found"

**Solution:** Install VLC
```bash
sudo apt-get update
sudo apt-get install -y vlc
```

### Problem: No audio

**Solution:** Configure audio output
```bash
sudo raspi-config
# Navigate to: System Options → Audio
# Choose: Headphones or HDMI
```

### Problem: Video stuttering

**Solution 1:** Use lower resolution
```bash
nano play-vlc-custom.sh
# Change to:
WIDTH=640
HEIGHT=480
```

**Solution 2:** Use hardware acceleration (Raspberry Pi specific)
```bash
cvlc --vout=mmal --codec=avcodec,any "$(cat url.txt)"
```

## Common Window Sizes

Edit `play-vlc-custom.sh` with these values:

```bash
# Small window (good for older Pi models)
WIDTH=640
HEIGHT=480

# Medium window
WIDTH=1280
HEIGHT=720

# Large window
WIDTH=1920
HEIGHT=1080

# Positioning (0,0 = top-left)
POS_X=0    # Distance from left
POS_Y=0    # Distance from top
```

## Auto-Start on Boot

### Method 1: Using Crontab

```bash
crontab -e
```

Add this line:
```bash
@reboot sleep 30 && /home/pi/qmed-utils/queuescreen/vlc/raspi/play-vlc-fullscreen.sh
```

### Method 2: Using Autostart (LXDE Desktop)

```bash
nano ~/.config/lxsession/LXDE-pi/autostart
```

Add:
```bash
@/home/pi/qmed-utils/queuescreen/vlc/raspi/play-vlc-fullscreen.sh
```

## Performance Tips for Raspberry Pi

1. **Close unnecessary programs** before playing
2. **Use Ethernet** instead of WiFi for stable streaming
3. **Overclock your Pi** (optional, at your own risk)
   ```bash
   sudo raspi-config
   # Performance Options → Overclock
   ```
4. **Disable desktop** for better performance:
   ```bash
   sudo raspi-config
   # System Options → Boot / Auto Login → Console
   ```
5. **Use `cvlc`** (command-line) instead of GUI VLC

## Kiosk Mode Setup (Digital Signage)

For a dedicated streaming display:

```bash
# 1. Disable screensaver
sudo apt-get install -y xscreensaver
# Disable in settings

# 2. Prevent screen blanking
nano ~/.config/lxsession/LXDE-pi/autostart
# Add:
@xset s off
@xset -dpms
@xset s noblank

# 3. Auto-start fullscreen player
@/home/pi/qmed-utils/queuescreen/vlc/raspi/play-vlc-fullscreen.sh
```

## Raspberry Pi Models Tested

✅ Raspberry Pi 3 Model B+
✅ Raspberry Pi 4 (all RAM variants)
✅ Raspberry Pi 400
✅ Raspberry Pi Zero 2 W (lower resolution recommended)

## Need Help?

Check the main README:
```bash
cat README.md
```

Or check VLC installation:
```bash
./check-vlc.sh
```

