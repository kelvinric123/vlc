@echo off
REM RTM TV2 - Extract URL and Play with VLC
REM All-in-one script

echo ====================================
echo RTM TV2 Extract and Play
echo ====================================
echo.

echo Step 1: Extracting URL...
echo.
python extract-rtm-url.py

if errorlevel 1 (
    echo.
    echo Failed to extract URL.
    pause
    exit /b 1
)

echo.
echo ====================================
echo Step 2: Launching VLC...
echo ====================================
echo.

REM Small delay
timeout /t 2 /nobreak >nul

REM Launch VLC player
call play-vlc.bat

