@echo off
REM Check VLC Installation

echo ====================================
echo VLC Installation Checker
echo ====================================
echo.

REM Find VLC executable
set "VLC_PATH="
set "VLC_FOUND=0"

echo Checking common VLC installation paths...
echo.

if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files\VideoLAN\VLC\vlc.exe"
    set "VLC_FOUND=1"
    echo [+] Found: C:\Program Files\VideoLAN\VLC\vlc.exe
)

if exist "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" (
    set "VLC_PATH=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
    set "VLC_FOUND=1"
    echo [+] Found: C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
)

where vlc >nul 2>&1
if %errorlevel% equ 0 (
    set "VLC_FOUND=1"
    echo [+] Found: VLC is in system PATH
)

echo.
echo ====================================

if "%VLC_FOUND%"=="1" (
    echo Status: VLC is installed! ✓
    echo.
    if not "%VLC_PATH%"=="" (
        echo VLC Location: %VLC_PATH%
        echo.
        REM Get VLC version
        echo VLC Version:
        "%VLC_PATH%" --version 2>nul | findstr /C:"VLC"
    )
    echo.
    echo You can now run: play-vlc.bat
) else (
    echo Status: VLC NOT found! ✗
    echo.
    echo Please install VLC Media Player:
    echo   Download from: https://www.videolan.org/vlc/
    echo.
    echo Default installation path should be:
    echo   C:\Program Files\VideoLAN\VLC\vlc.exe
)

echo ====================================
echo.
pause

