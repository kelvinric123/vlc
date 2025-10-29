# Windows vs Raspberry Pi - Command Comparison

This guide shows the differences between Windows and Raspberry Pi versions.

## File Extensions

| Windows | Raspberry Pi | Purpose |
|---------|--------------|---------|
| `.bat` | `.sh` | Script files |

## Installation

### Windows
```batch
# Download VLC from: https://www.videolan.org/vlc/
# Install using the installer
check-vlc.bat
```

### Raspberry Pi
```bash
sudo apt-get update
sudo apt-get install -y vlc
./check-vlc.sh

# Or use the installer
chmod +x install.sh
./install.sh
```

## Making Scripts Executable

### Windows
✅ Not needed - `.bat` files are automatically executable

### Raspberry Pi
⚠️ Required - must make `.sh` files executable:
```bash
chmod +x *.sh
```

## VLC Command

### Windows
```batch
# Uses full path or 'vlc' if in PATH
"C:\Program Files\VideoLAN\VLC\vlc.exe" [options] "url"
```

### Raspberry Pi
```bash
# Uses cvlc (command-line VLC)
cvlc [options] "url"
```

## Path Separators

### Windows
```batch
set VLC_PATH=C:\Program Files\VideoLAN\VLC\vlc.exe
```

### Raspberry Pi
```bash
VLC_PATH=/usr/bin/cvlc
```

## Config File Locations

### Windows
```
%APPDATA%\vlc\vlcrc
# Example: C:\Users\YourName\AppData\Roaming\vlc\vlcrc
```

### Raspberry Pi
```
~/.config/vlc/vlcrc
# Example: /home/pi/.config/vlc/vlcrc
```

## Environment Variables

### Windows
```batch
set STREAM_URL=https://example.com/stream.m3u8
echo %STREAM_URL%
```

### Raspberry Pi
```bash
STREAM_URL="https://example.com/stream.m3u8"
echo "$STREAM_URL"
```

## Reading Files

### Windows
```batch
set /p STREAM_URL=<url.txt
```

### Raspberry Pi
```bash
STREAM_URL=$(cat url.txt)
```

## Checking Commands

### Windows
```batch
where vlc >nul 2>&1
if %errorlevel% equ 0 (
    echo VLC found
)
```

### Raspberry Pi
```bash
if command -v cvlc &> /dev/null; then
    echo "VLC found"
fi
```

## Script Comparison

### Extract URL

**Windows:** `extract-rtm-url.py` (Python script)
```batch
python extract-rtm-url.py
```

**Raspberry Pi:** `extract-rtm-url.sh` (Bash script)
```bash
./extract-rtm-url.sh
```

### Play VLC (Custom)

**Windows:** `play-vlc-custom.bat`
```batch
play-vlc-custom.bat
```

**Raspberry Pi:** `play-vlc-custom.sh`
```bash
./play-vlc-custom.sh
```

## VLC Options (Same on Both!)

Good news! VLC command-line options are the same:

```
--no-embedded-video
--width=800
--height=600
--video-x=0
--video-y=0
--video-on-top
--no-video-deco
--fullscreen
```

## File Structure Comparison

```
vlc/                          vlc/raspi/
├── play-vlc.bat             ├── play-vlc.sh
├── play-vlc-custom.bat      ├── play-vlc-custom.sh
├── play-vlc-simple.bat      ├── play-vlc-simple.sh
├── check-vlc.bat            ├── check-vlc.sh
├── setup-vlc-preferences.bat├── setup-vlc-preferences.sh
├── extract-rtm-url.py       ├── extract-rtm-url.sh
├── url.txt                  ├── url.txt
├── README.md                ├── README.md
└── QUICK-START.md           └── QUICK-START.md
```

## Common Tasks Side-by-Side

| Task | Windows | Raspberry Pi |
|------|---------|--------------|
| Check VLC | `check-vlc.bat` | `./check-vlc.sh` |
| Show URL | `show-url.bat` | `./show-url.sh` |
| Extract URL | `python extract-rtm-url.py` | `./extract-rtm-url.sh` |
| Play simple | `play-vlc-simple.bat` | `./play-vlc-simple.sh` |
| Play custom | `play-vlc-custom.bat` | `./play-vlc-custom.sh` |
| Play fullscreen | `play-vlc-fullscreen.bat` | `./play-vlc-fullscreen.sh` |
| Setup VLC | `setup-vlc-preferences.bat` | `./setup-vlc-preferences.sh` |
| All-in-one | `extract-and-play.bat` | `./extract-and-play.sh` |

## Quick Setup Comparison

### Windows
1. Install VLC from website
2. Run `check-vlc.bat`
3. Run `setup-vlc-preferences.bat`
4. Run `play-vlc-custom.bat`

### Raspberry Pi
1. Run `chmod +x install.sh`
2. Run `./install.sh` (does everything!)
3. Run `./play-vlc-custom.sh`

Or manually:
1. Run `sudo apt-get install -y vlc`
2. Run `chmod +x *.sh`
3. Run `./setup-vlc-preferences.sh`
4. Run `./play-vlc-custom.sh`

## Key Differences Summary

| Feature | Windows | Raspberry Pi |
|---------|---------|--------------|
| Script type | Batch (`.bat`) | Shell (`.sh`) |
| Python needed | Yes (for extractor) | No (uses bash) |
| Executable perms | Auto | Must `chmod +x` |
| VLC command | `vlc.exe` | `cvlc` |
| Config path | `%APPDATA%\vlc\` | `~/.config/vlc/` |
| Path separator | `\` | `/` |
| Line endings | CRLF | LF |
| Case sensitivity | No | Yes |
| Hardware accel | DirectX/OpenGL | MMAL (Pi specific) |

## Testing URL Extraction

### Windows
```batch
cd vlc
python extract-rtm-url.py
type url.txt
```

### Raspberry Pi
```bash
cd vlc/raspi
./extract-rtm-url.sh
cat url.txt
```

## Both Work the Same!

Despite the syntax differences, both versions:
- ✅ Extract the same URLs
- ✅ Use the same VLC options
- ✅ Support custom window sizes
- ✅ Have the same features
- ✅ Work reliably

Choose the version that matches your platform! 🚀

