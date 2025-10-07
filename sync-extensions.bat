@echo off
REM Cursor Extension Sync Script for Windows
REM This script exports and imports Cursor extensions

setlocal enabledelayedexpansion

REM Check if command is provided
if "%~1"=="" (
    echo [ERROR] No command specified
    call :show_help
    exit /b 1
)

REM Detect Cursor config directory
set "CURSOR_CONFIG_DIR=%APPDATA%\Cursor"
set "CURSOR_EXTENSIONS_DIR=%USERPROFILE%\.vscode\extensions"

REM Check if extensions exist in Cursor's own directory first
if exist "%CURSOR_CONFIG_DIR%\User\extensions" (
    set "CURSOR_EXTENSIONS_DIR=%CURSOR_CONFIG_DIR%\User\extensions"
) else if exist "%USERPROFILE%\.vscode\extensions" (
    set "CURSOR_EXTENSIONS_DIR=%USERPROFILE%\.vscode\extensions"
) else if exist "%APPDATA%\Code\User\extensions" (
    set "CURSOR_EXTENSIONS_DIR=%APPDATA%\Code\User\extensions"
)

REM Check if Cursor is installed
if not exist "%CURSOR_CONFIG_DIR%" (
    echo [ERROR] Cursor configuration directory not found at: %CURSOR_CONFIG_DIR%
    echo Please make sure Cursor is installed and has been run at least once.
    exit /b 1
)

if "%~1"=="export" goto :export_extensions
if "%~1"=="import" goto :import_extensions
if "%~1"=="help" goto :show_help
if "%~1"=="-h" goto :show_help
if "%~1"=="--help" goto :show_help

echo [ERROR] Unknown command: %~1
call :show_help
exit /b 1

:export_extensions
echo [INFO] Exporting Cursor extensions...

REM Create extensions directory if it doesn't exist
if not exist "extensions" mkdir extensions

REM Copy extensions folder
echo [INFO] Looking for extensions in: %CURSOR_EXTENSIONS_DIR%
if exist "%CURSOR_EXTENSIONS_DIR%" (
    xcopy "%CURSOR_EXTENSIONS_DIR%\*" "extensions\" /E /I /Y >nul 2>&1
    echo [INFO] Extensions exported to .\extensions\
) else (
    echo [WARNING] No extensions found to export
    echo [INFO] Checked location: %CURSOR_EXTENSIONS_DIR%
)

REM Export settings
if exist "%CURSOR_CONFIG_DIR%\User\settings.json" (
    copy "%CURSOR_CONFIG_DIR%\User\settings.json" "settings.json" >nul
    echo [INFO] Settings exported to .\settings.json
) else (
    echo [WARNING] No settings.json found
)

REM Export keybindings
if exist "%CURSOR_CONFIG_DIR%\User\keybindings.json" (
    copy "%CURSOR_CONFIG_DIR%\User\keybindings.json" "keybindings.json" >nul
    echo [INFO] Keybindings exported to .\keybindings.json
) else (
    echo [WARNING] No keybindings.json found
)

REM Create extensions list
if exist "extensions" (
    dir /b "extensions" > extensions-list.txt 2>nul
    echo [INFO] Extensions list created: extensions-list.txt
)

echo [INFO] Export completed!
goto :end

:import_extensions
echo [INFO] Importing Cursor extensions...

REM Create Cursor config directory if it doesn't exist
if not exist "%CURSOR_CONFIG_DIR%\User" mkdir "%CURSOR_CONFIG_DIR%\User"

REM Import extensions
if exist "extensions" (
    echo [INFO] Importing extensions to: %CURSOR_EXTENSIONS_DIR%
    if not exist "%CURSOR_EXTENSIONS_DIR%" mkdir "%CURSOR_EXTENSIONS_DIR%"
    xcopy "extensions\*" "%CURSOR_EXTENSIONS_DIR%\" /E /I /Y >nul 2>&1
    echo [INFO] Extensions imported from .\extensions\
) else (
    echo [WARNING] No extensions directory found to import
)

REM Import settings
if exist "settings.json" (
    copy "settings.json" "%CURSOR_CONFIG_DIR%\User\settings.json" >nul
    echo [INFO] Settings imported from .\settings.json
) else (
    echo [WARNING] No settings.json found to import
)

REM Import keybindings
if exist "keybindings.json" (
    copy "keybindings.json" "%CURSOR_CONFIG_DIR%\User\keybindings.json" >nul
    echo [INFO] Keybindings imported from .\keybindings.json
) else (
    echo [WARNING] No keybindings.json found to import
)

echo [INFO] Import completed!
echo [WARNING] Please restart Cursor for changes to take effect.
goto :end

:show_help
echo Cursor Extension Sync Script
echo.
echo Usage: %~nx0 [COMMAND]
echo.
echo Commands:
echo   export    Export extensions and settings from Cursor
echo   import    Import extensions and settings to Cursor
echo   help      Show this help message
echo.
echo Examples:
echo   %~nx0 export    # Export current Cursor configuration
echo   %~nx0 import    # Import configuration to Cursor
goto :end

:end
endlocal
