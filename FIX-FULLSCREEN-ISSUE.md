# Fix VLC Auto-Resizing to Full Screen

## Problem
VLC window opens at full screen size, ignoring the width/height parameters in the batch file.

## Solution 1: Use Simplified Batch Files (RECOMMENDED)

The batch files have been updated to use only reliable, well-tested VLC options:
- `--no-embedded-video` - Separate video window
- `--no-autoscale` - Prevents video from auto-scaling
- `--width` / `--height` - Window dimensions
- `--video-x` / `--video-y` - Window position
- `--video-on-top` - Always on top
- `--no-video-deco` - Borderless

### Try these in order:

1. **`play-vlc-simple.bat`** - Ultra simple (just opens VLC, no special options)
2. **`play-vlc-custom.bat`** - Custom size with basic options
3. **`play-vlc-small.bat`** - Small 640x480 window

If you get "invalid options" error, try `play-vlc-simple.bat` first.

## Solution 2: Modify VLC Preferences (If Still Not Working)

If VLC still auto-resizes, you need to change VLC's internal settings:

### Step-by-Step:

1. **Open VLC Media Player** (not through the batch file)
   - Start VLC normally from Start Menu

2. **Go to Preferences**
   - Click `Tools` → `Preferences`
   - Or press `Ctrl + P`

3. **Disable Auto-Resize**
   - Make sure you're on the `Interface` tab
   - Look for `Resize interface to video size`
   - **UNCHECK** this option

4. **Advanced Settings (if needed)**
   - At bottom left, click `Show settings: All` (radio button)
   - Navigate to: `Interface` → `Main interfaces` → `Qt`
   - Find `Resize interface to native video size`
   - **UNCHECK** this option

5. **Save and Close**
   - Click `Save` button
   - Close VLC completely
   - Run `play-vlc-custom.bat` again

## Solution 3: Create VLC Config File

Create a VLC configuration to force these settings:

1. **Find VLC config folder:**
   - Windows: `C:\Users\YourName\AppData\Roaming\vlc\`

2. **Edit `vlcrc` file** (or create if doesn't exist)
   - Add these lines:
   ```
   qt-video-autoresize=0
   no-autoscale=1
   no-video-deco=1
   ```

3. **Save and restart VLC**

## Solution 4: Alternative - Use VLC with Config

Create a custom VLC shortcut with a config file:

```batch
"%VLC_PATH%" "%STREAM_URL%" ^
    --config="custom-vlc-config.txt"
```

Where `custom-vlc-config.txt` contains all your settings.

## Testing the Fix

After applying any solution, test with:

```batch
cd qmed-utils\queuescreen\vlc
play-vlc-custom.bat
```

The window should now open at **640x480** (not full screen).

## Still Having Issues?

If none of the above works, the video stream itself might have metadata forcing a specific size. In that case:

### Option A: Try a different video output module
Add to the batch file:
```batch
--vout=directx
```
or
```batch
--vout=gl
```

### Option B: Use scaling
Add zoom level:
```batch
--zoom=0.5
```

This will force the video to display at 50% of its native size.

## Quick Test

Run this command manually to test:
```batch
"C:\Program Files\VideoLAN\VLC\vlc.exe" ^
  "https://d25tgymtnqzu8s.cloudfront.net/smil:tv2/chunklist_b2596000_slENG.m3u8?id=2" ^
  --width=640 --height=480 ^
  --video-x=0 --video-y=0 ^
  --no-autoscale ^
  --qt-video-autoresize=0 ^
  --no-fullscreen ^
  --no-video-deco
```

If this works, the batch file should work too.

