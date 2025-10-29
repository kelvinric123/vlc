@echo off
REM Setup VLC Preferences to Prevent Auto-Resize
REM This modifies VLC's config file directly (most reliable method)

echo ====================================
echo VLC Preferences Setup
echo ====================================
echo.
echo This will configure VLC to NOT auto-resize windows
echo.

REM Find VLC config directory
set "VLC_CONFIG_DIR=%APPDATA%\vlc"

if not exist "%VLC_CONFIG_DIR%" (
    echo Creating VLC config directory...
    mkdir "%VLC_CONFIG_DIR%"
)

echo VLC Config Directory: %VLC_CONFIG_DIR%
echo.

REM Check if vlcrc exists
if exist "%VLC_CONFIG_DIR%\vlcrc" (
    echo Backing up existing vlcrc...
    copy "%VLC_CONFIG_DIR%\vlcrc" "%VLC_CONFIG_DIR%\vlcrc.backup" >nul
    echo Backup saved: vlcrc.backup
    echo.
)

echo Writing VLC preferences...
echo.

REM Create/update vlcrc with our settings
(
echo # VLC Preferences - Modified by play-vlc scripts
echo # Disable auto-resize to prevent fullscreen issues
echo.
echo [qt]
echo qt-video-autoresize=0
echo.
echo [core]
echo no-autoscale=1
echo video-on-top=1
echo.
) > "%VLC_CONFIG_DIR%\vlcrc"

echo ====================================
echo SUCCESS!
echo ====================================
echo.
echo VLC preferences have been configured:
echo   - Auto-resize: DISABLED
echo   - Auto-scale: DISABLED
echo   - Always on top: ENABLED
echo.
echo Config file: %VLC_CONFIG_DIR%\vlcrc
echo.
echo Now try running:
echo   play-vlc-custom.bat
echo.
echo VLC should now respect the window size!
echo ====================================
echo.
pause

