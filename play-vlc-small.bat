@echo off
REM RTM TV2 VLC Player - Force Small Window
REM This version uses aggressive settings to prevent fullscreen

echo ====================================
echo RTM TV2 VLC Player (Small Window)
echo ====================================
echo.

REM Check if url.txt exists
if not exist "url.txt" (
    echo Error: url.txt not found!
    echo Please run extract-rtm-url.py first
    pause
    exit /b 1
)

REM Read URL from file
set /p STREAM_URL=<url.txt

REM Find VLC executable
set "VLC_PATH="
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files\VideoLAN\VLC\vlc.exe"
) else if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
) else (
    where vlc >nul 2>&1
    if %errorlevel% equ 0 (
        set "VLC_PATH=vlc"
    )
)

if "%VLC_PATH%"=="" (
    echo Error: VLC not found!
    pause
    exit /b 1
)

echo Stream URL: %STREAM_URL%
echo Using VLC: %VLC_PATH%
echo.
echo Forcing window size: 640x480 at position (0,0)
echo With aggressive anti-fullscreen settings...
echo.

REM Launch VLC with reliable options only (small window)
"%VLC_PATH%" ^
    --no-embedded-video ^
    --no-autoscale ^
    --width=640 ^
    --height=480 ^
    --video-x=0 ^
    --video-y=0 ^
    --video-on-top ^
    --no-video-deco ^
    "%STREAM_URL%"

echo.
echo VLC closed.
pause

