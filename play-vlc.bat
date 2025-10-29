@echo off
REM RTM TV2 VLC Player - Borderless, Top-Left, Always on Top
echo ====================================
echo RTM TV2 VLC Player
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

echo Stream URL: %STREAM_URL%
echo.

REM Find VLC executable
set "VLC_PATH="

REM Check common installation paths
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files\VideoLAN\VLC\vlc.exe"
) else if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
) else (
    REM Try to use vlc from PATH
    where vlc >nul 2>&1
    if %errorlevel% equ 0 (
        set "VLC_PATH=vlc"
    )
)

REM Check if VLC was found
if "%VLC_PATH%"=="" (
    echo Error: VLC not found!
    echo.
    echo Please install VLC from: https://www.videolan.org/
    echo Or make sure it's installed at:
    echo   C:\Program Files\VideoLAN\VLC\vlc.exe
    echo   C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
    echo.
    pause
    exit /b 1
)

echo Using VLC: %VLC_PATH%
echo.
echo Starting VLC with:
echo  - Borderless window
echo  - Always on top
echo  - Position: Top-Left (0, 0)
echo  - Size: 800x600
echo.

REM Launch VLC with reliable, well-tested options only
"%VLC_PATH%" ^
    --no-embedded-video ^
    --no-autoscale ^
    --width=800 ^
    --height=600 ^
    --video-x=0 ^
    --video-y=0 ^
    --video-on-top ^
    --no-video-deco ^
    "%STREAM_URL%"

echo.
echo VLC closed.
pause

