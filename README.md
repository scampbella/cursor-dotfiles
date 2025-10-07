# Cursor Extensions Sync

A lightweight Python tool to sync Cursor extensions and settings across different installations.

## Why This Exists

Cursor doesn't have built-in extension syncing like VS Code. This tool solves that by:
- Storing only extension IDs (not binary files) - keeping the repo tiny
- Syncing settings and keybindings
- Working across Windows, macOS, and Linux

## Quick Start

1. **Export your current setup:**
   `ash
   python sync_extensions.py export
   `

2. **On a new machine, import the setup:**
   `ash
   python sync_extensions.py import
   `

3. **Check status anytime:**
   `ash
   python sync_extensions.py status
   `

## Files Managed

- extensions.txt - List of extension IDs (lightweight text file)
- settings.json - Cursor settings
- keybindings.json - Cursor keybindings

## Repository Size

- **Before optimization:** ~1.7GB (43,131 files with binary extensions)
- **After optimization:** ~42KB (19 files, text-only)

## Requirements

- Python 3.6+
- Cursor installed and in PATH
- No external dependencies (uses only Python standard library)

## Commands

- export - Export current Cursor setup
- import - Import and apply setup
- status - Show current status
- help - Show detailed help

## How It Works

Instead of storing massive binary extension files, this tool:
1. Extracts extension IDs from your current installation
2. Stores them in a simple text file
3. Uses Cursor's CLI to install extensions by ID
4. Syncs settings and keybindings directly

This approach is much more efficient and keeps your repository lightweight while providing the same functionality.
