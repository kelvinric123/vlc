@echo off
REM RTM TV2 VLC Player - Custom Size
REM Edit WIDTH and HEIGHT below to customize window size

echo ====================================
echo RTM TV2 VLC Player (Custom Size)
echo ====================================
echo.

REM === CUSTOMIZE THESE VALUES ===
REM Window will open in WINDOWED mode (not fullscreen)
REM After seeing the window, adjust these values to your preference
set WIDTH=640
set HEIGHT=480
set POS_X=0
set POS_Y=0
REM ==============================

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
    pause
    exit /b 1
)

echo Using VLC: %VLC_PATH%
echo Window Settings:
echo   Size: %WIDTH%x%HEIGHT%
echo   Position: (%POS_X%, %POS_Y%)
echo.
echo Starting VLC...
echo.

REM Launch VLC with reliable, well-tested command-line options only
REM Using minimal set of options to avoid "invalid options" error
"%VLC_PATH%" ^
    --no-embedded-video ^
    --no-autoscale ^
    --width=%WIDTH% ^
    --height=%HEIGHT% ^
    --video-x=%POS_X% ^
    --video-y=%POS_Y% ^
    --video-on-top ^
    --no-video-deco ^
    "%STREAM_URL%"

echo.
echo VLC closed.
pause

