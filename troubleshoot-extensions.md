# Cursor Extension Sync Troubleshooting

## If Extensions Don't Appear After Import

### 1. Restart Cursor Completely
- Close Cursor completely (not just the window)
- Reopen Cursor
- Check the Extensions panel (Ctrl+Shift+X)

### 2. Check Extension Status
- Open Extensions panel (Ctrl+Shift+X)
- Look for your extensions in the "Installed" section
- They might show as "Disabled" - if so, click "Enable"

### 3. Force Extension Refresh
- Open Command Palette (Ctrl+Shift+P)
- Type "Developer: Reload Window" and run it
- Or try "Developer: Restart Extension Host"

### 4. Check Extensions Directory
The extensions should be in one of these locations on Windows:
- `%USERPROFILE%\.vscode\extensions\`
- `%APPDATA%\Cursor\User\extensions\`
- `%APPDATA%\Code\User\extensions\`

### 5. Manual Extension Installation
If extensions still don't appear, you can:
1. Go to Extensions panel
2. Search for each extension by name
3. Click "Install" (they should install instantly since files are already there)

### 6. Check Extension List
Look at `extensions-list.txt` to see what should be installed:
- Python extensions
- Java extensions  
- Material Icon Theme
- Code Runner
- HTML/CSS support
- And more...

## Common Issues

### Extensions Show as "Disabled"
- Click the "Enable" button for each extension
- Some extensions may need to be reinstalled

### Extensions Don't Load
- Check if Cursor has permission to access the extensions directory
- Try running Cursor as Administrator

### Settings/Keybindings Not Applied
- Check if `settings.json` and `keybindings.json` were copied to:
  - `%APPDATA%\Cursor\User\`

## Verification Steps

1. **Check Extensions Panel**: Should show all your extensions as installed
2. **Check Settings**: Your custom settings should be applied
3. **Check Keybindings**: Custom shortcuts should work
4. **Test Functionality**: Try using Python/Java features to verify extensions work

## If Nothing Works

Try the manual approach:
1. Export extensions list: `sync-extensions.bat export`
2. Install each extension manually from the Extensions marketplace
3. The extensions should install instantly since the files are already there
