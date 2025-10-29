@echo off
REM RTM TV2 VLC Player - Ultra Simple (Most Compatible)
REM Uses only the most basic, universally-supported VLC options

echo ====================================
echo RTM TV2 VLC Player (Simple Mode)
echo ====================================
echo.

REM Check if url.txt exists
if not exist "url.txt" (
    echo Error: url.txt not found!
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
)

if "%VLC_PATH%"=="" (
    echo Error: VLC not found!
    pause
    exit /b 1
)

echo Stream URL: %STREAM_URL%
echo Using VLC: %VLC_PATH%
echo.
echo Starting VLC with basic options only...
echo.

REM Launch VLC with ONLY the most basic, reliable options
REM This should work on all VLC versions
"%VLC_PATH%" "%STREAM_URL%"

echo.
echo VLC closed.
pause

