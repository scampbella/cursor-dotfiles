# Cursor Extension Sync

This repository helps you sync your Cursor IDE extensions, settings, and keybindings across different devices using GitHub.

## Features

- ✅ Sync extensions across Mac, Windows, and Linux
- ✅ Export/import settings and keybindings
- ✅ Cross-platform scripts (Bash for Mac/Linux, Batch for Windows)
- ✅ Easy-to-use command-line interface

## Quick Start

### 1. Clone this repository

```bash
git clone https://github.com/YOUR_USERNAME/cursor-dotfiles.git
cd cursor-dotfiles
```

### 2. Export your current Cursor configuration

**On Mac/Linux:**
```bash
chmod +x sync-extensions.sh
./sync-extensions.sh export
```

**On Windows:**
```cmd
sync-extensions.bat export
```

### 3. Commit and push to GitHub

```bash
git add .
git commit -m "Initial Cursor configuration export"
git push origin main
```

### 4. Import on another device

**On Mac/Linux:**
```bash
./sync-extensions.sh import
```

**On Windows:**
```cmd
sync-extensions.bat import
```

## Usage

### Export Configuration
Exports your current Cursor extensions, settings, and keybindings to the repository.

```bash
# Mac/Linux
./sync-extensions.sh export

# Windows
sync-extensions.bat export
```

### Import Configuration
Imports extensions, settings, and keybindings from the repository to your Cursor installation.

```bash
# Mac/Linux
./sync-extensions.sh import

# Windows
sync-extensions.bat import
```

## What Gets Synced

- **Extensions**: All installed Cursor extensions
- **Settings**: Your `settings.json` configuration
- **Keybindings**: Your custom keybindings from `keybindings.json`

## File Structure

```
cursor-dotfiles/
├── sync-extensions.sh      # Mac/Linux sync script
├── sync-extensions.bat     # Windows sync script
├── extensions/             # Exported extensions
├── settings.json          # Exported settings
├── keybindings.json       # Exported keybindings
├── extensions-list.txt    # List of installed extensions
└── README.md              # This file
```

## Troubleshooting

### Cursor not found
Make sure Cursor is installed and has been run at least once to create the configuration directory.

**Default locations:**
- Mac: `~/Library/Application Support/Cursor`
- Windows: `%APPDATA%\Cursor`
- Linux: `~/.config/Cursor`

### Extensions not working after import
1. Restart Cursor completely
2. Check if extensions are enabled in the Extensions panel
3. Some extensions may need to be reinstalled if they have platform-specific dependencies

### Permission issues
Make sure the scripts have execute permissions:

```bash
chmod +x sync-extensions.sh
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License - feel free to use this for your own Cursor configuration syncing.
