@echo off
REM Verification script to check if extensions were imported correctly

echo [INFO] Verifying Cursor extension sync...

REM Check if extensions directory exists
if exist "extensions" (
    echo [INFO] Extensions directory found locally
    dir /b "extensions" | find /c /v "" > temp_count.txt
    set /p local_count=<temp_count.txt
    del temp_count.txt
    echo [INFO] Local extensions count: %local_count%
) else (
    echo [ERROR] No local extensions directory found
    goto :end
)

REM Check Windows extensions directories
echo.
echo [INFO] Checking Windows extensions directories...

set "CURSOR_EXTENSIONS_DIR=%USERPROFILE%\.vscode\extensions"
if exist "%CURSOR_EXTENSIONS_DIR%" (
    echo [INFO] Found extensions in: %CURSOR_EXTENSIONS_DIR%
    dir /b "%CURSOR_EXTENSIONS_DIR%" | find /c /v "" > temp_count.txt
    set /p win_count=<temp_count.txt
    del temp_count.txt
    echo [INFO] Windows extensions count: %win_count%
) else (
    echo [WARNING] No extensions found in: %CURSOR_EXTENSIONS_DIR%
)

set "CURSOR_EXTENSIONS_DIR=%APPDATA%\Cursor\User\extensions"
if exist "%CURSOR_EXTENSIONS_DIR%" (
    echo [INFO] Found extensions in: %CURSOR_EXTENSIONS_DIR%
    dir /b "%CURSOR_EXTENSIONS_DIR%" | find /c /v "" > temp_count.txt
    set /p win_count=<temp_count.txt
    del temp_count.txt
    echo [INFO] Windows extensions count: %win_count%
) else (
    echo [WARNING] No extensions found in: %CURSOR_EXTENSIONS_DIR%
)

REM Check settings
echo.
echo [INFO] Checking settings...
if exist "%APPDATA%\Cursor\User\settings.json" (
    echo [INFO] Settings file found
) else (
    echo [WARNING] Settings file not found
)

if exist "settings.json" (
    echo [INFO] Local settings file found
) else (
    echo [WARNING] Local settings file not found
)

REM Show extension list
echo.
echo [INFO] Expected extensions:
if exist "extensions-list.txt" (
    type "extensions-list.txt"
) else (
    echo [WARNING] No extensions list found
)

echo.
echo [INFO] Next steps:
echo 1. Restart Cursor completely
echo 2. Open Extensions panel (Ctrl+Shift+X)
echo 3. Check if extensions appear in "Installed" section
echo 4. Enable any disabled extensions
echo 5. If still not working, try "Developer: Reload Window" command

:end
pause
