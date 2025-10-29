# Quick Start Guide - RTM TV2 VLC Player

## The Right Way to Start (Step by Step)

### 1️⃣ First Time Setup (Only Once)

**Step A: Check if VLC is installed**
```batch
check-vlc.bat
```

If not installed, download from: https://www.videolan.org/vlc/

**Step B: Configure VLC preferences**
```batch
setup-vlc-preferences.bat
```

This prevents VLC from auto-resizing to fullscreen. ⭐ **IMPORTANT!**

### 2️⃣ Test VLC (Simple Mode)

```batch
play-vlc-simple.bat
```

This uses the most basic VLC options. If this works, you're good to go!

### 3️⃣ Try Custom Size

Edit `play-vlc-custom.bat` and change these lines:
```batch
set WIDTH=640
set HEIGHT=480
set POS_X=0
set POS_Y=0
```

Then run:
```batch
play-vlc-custom.bat
```

### 4️⃣ Measure and Adjust

Once VLC opens, you can see the window. Tell me:
- What size do you want? (width x height)
- What position? (x, y from top-left)

I'll update the batch file for you!

## Troubleshooting

### Problem: "cmd line options invalid or no plugin"

**Solution:** Use the simple version first
```batch
play-vlc-simple.bat
```

Then run the setup:
```batch
setup-vlc-preferences.bat
```

### Problem: VLC still opens fullscreen

**Manual Fix:**
1. Open VLC normally (from Start Menu)
2. Go to `Tools` → `Preferences`
3. Uncheck `Resize interface to video size`
4. Click `Save`
5. Close VLC completely
6. Try again: `play-vlc-custom.bat`

### Problem: Window size is wrong

Edit the batch file and change WIDTH/HEIGHT values:
```batch
notepad play-vlc-custom.bat
```

Change lines 13-14:
```batch
set WIDTH=1920    # Your desired width
set HEIGHT=1080   # Your desired height
```

## Files Overview

| File | Purpose | When to Use |
|------|---------|-------------|
| `play-vlc-simple.bat` | Basic player, no options | When getting errors |
| `play-vlc-custom.bat` | Custom size/position | Main player ⭐ |
| `play-vlc-small.bat` | Small 640x480 test window | For testing |
| `play-vlc.bat` | 800x600 at top-left | Quick standard size |
| `setup-vlc-preferences.bat` | Fix VLC config | Run once at setup |
| `check-vlc.bat` | Check VLC installation | Troubleshooting |

## Recommended Workflow

```
1. check-vlc.bat           → Verify VLC is installed
2. setup-vlc-preferences.bat → Configure VLC (once)
3. play-vlc-simple.bat     → Test it works
4. Edit play-vlc-custom.bat → Set your size
5. play-vlc-custom.bat     → Use this daily
```

## Common Window Sizes

```batch
# Small corner window
set WIDTH=640
set HEIGHT=480

# Medium window
set WIDTH=1280
set HEIGHT=720

# Large window
set WIDTH=1920
set HEIGHT=1080

# Custom positioning (0,0 = top-left)
set POS_X=0    # Distance from left
set POS_Y=0    # Distance from top
```

## Need Help?

Just tell me what you want and I'll update the files:
- "Make it 1280x720"
- "Put it in the bottom right corner"
- "Make it half my screen size"

I'll adjust the batch file for you! 🚀

