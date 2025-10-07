#!/usr/bin/env python3
"""
Cursor Extensions Sync Tool

A lightweight Python script to sync Cursor extensions across different installations
by managing extension lists instead of binary files.
"""

import json
import os
import subprocess
import sys
import platform
from pathlib import Path
from typing import List, Dict, Any


class CursorExtensionSync:
    def __init__(self):
        self.script_dir = Path(__file__).parent
        self.extensions_file = self.script_dir / "extensions.txt"
        self.settings_file = self.script_dir / "settings.json"
        self.keybindings_file = self.script_dir / "keybindings.json"
        
        # Determine Cursor data directory based on OS
        self.cursor_data_dir = self._get_cursor_data_dir()
        
    def _get_cursor_data_dir(self) -> Path:
        """Get the Cursor data directory based on the operating system."""
        system = platform.system().lower()
        
        if system == "windows":
            return Path(os.environ.get("APPDATA", "")) / "Cursor" / "User"
        elif system == "darwin":  # macOS
            return Path.home() / "Library" / "Application Support" / "Cursor" / "User"
        else:  # Linux
            return Path.home() / ".config" / "Cursor" / "User"
    
    def get_installed_extensions(self) -> List[str]:
        """Get list of currently installed extensions."""
        # Try different possible locations for Cursor executable
        cursor_paths = [
            "cursor",  # If in PATH
            r"C:\Program Files\cursor\resources\app\bin\cursor.cmd",  # Windows default
            r"C:\Users\{}\AppData\Local\Programs\cursor\resources\app\bin\cursor.cmd".format(os.environ.get("USERNAME", "")),  # User install
        ]
        
        for cursor_path in cursor_paths:
            try:
                result = subprocess.run(
                    [cursor_path, "--list-extensions", "--show-versions"],
                    capture_output=True,
                    text=True,
                    check=True
                )
                return [line.strip() for line in result.stdout.splitlines() if line.strip()]
            except (subprocess.CalledProcessError, FileNotFoundError):
                continue
        
        print("Error: Could not run 'cursor --list-extensions'. Make sure Cursor is installed and accessible.")
        return []
    
    def save_extensions(self, extensions: List[str]) -> None:
        """Save extension list to file."""
        with open(self.extensions_file, 'w', encoding='utf-8') as f:
            for ext in sorted(extensions):
                f.write(f"{ext}\n")
        print(f"Saved {len(extensions)} extensions to {self.extensions_file}")
    
    def load_extensions(self) -> List[str]:
        """Load extension list from file."""
        if not self.extensions_file.exists():
            return []
        
        with open(self.extensions_file, 'r', encoding='utf-8') as f:
            return [line.strip() for line in f.readlines() if line.strip()]
    
    def install_extensions(self, extensions: List[str]) -> None:
        """Install extensions from list, skipping already installed ones."""
        if not extensions:
            print("No extensions to install.")
            return
        
        # Find working Cursor executable
        cursor_paths = [
            "cursor",  # If in PATH
            r"C:\Program Files\cursor\resources\app\bin\cursor.cmd",  # Windows default
            r"C:\Users\{}\AppData\Local\Programs\cursor\resources\app\bin\cursor.cmd".format(os.environ.get("USERNAME", "")),  # User install
        ]
        
        cursor_path = None
        for path in cursor_paths:
            try:
                subprocess.run([path, "--version"], check=True, capture_output=True)
                cursor_path = path
                break
            except (subprocess.CalledProcessError, FileNotFoundError):
                continue
        
        if not cursor_path:
            print("Error: Could not find Cursor executable.")
            return
        
        # Get currently installed extensions
        print("Checking for already installed extensions...")
        installed_extensions = self.get_installed_extensions()
        
        # Filter out already installed extensions
        extensions_to_install = []
        already_installed = []
        
        for ext in extensions:
            # Check if extension is already installed (with or without version)
            ext_id = ext.split('@')[0] if '@' in ext else ext
            is_installed = any(installed_ext.split('@')[0] == ext_id for installed_ext in installed_extensions)
            
            if is_installed:
                already_installed.append(ext)
            else:
                extensions_to_install.append(ext)
        
        # Report status
        if already_installed:
            print(f"[OK] {len(already_installed)} extensions already installed:")
            for ext in already_installed:
                print(f"  - {ext}")
        
        if not extensions_to_install:
            print("All extensions are already installed!")
            return
        
        print(f"\nInstalling {len(extensions_to_install)} new extensions...")
        for i, ext in enumerate(extensions_to_install, 1):
            print(f"[{i}/{len(extensions_to_install)}] Installing {ext}...")
            try:
                subprocess.run(
                    [cursor_path, "--install-extension", ext],
                    check=True,
                    capture_output=True
                )
                print(f"  [OK] Successfully installed {ext}")
            except subprocess.CalledProcessError as e:
                print(f"  [ERROR] Warning: Failed to install {ext}: {e}")
    
    def sync_settings(self) -> None:
        """Sync Cursor settings."""
        if not self.settings_file.exists():
            print("No settings.json found to sync.")
            return
        
        cursor_settings = self.cursor_data_dir / "settings.json"
        cursor_settings.parent.mkdir(parents=True, exist_ok=True)
        
        # Copy settings
        with open(self.settings_file, 'r', encoding='utf-8') as src:
            with open(cursor_settings, 'w', encoding='utf-8') as dst:
                dst.write(src.read())
        
        print(f"Synced settings to {cursor_settings}")
    
    def sync_keybindings(self) -> None:
        """Sync Cursor keybindings."""
        if not self.keybindings_file.exists():
            print("No keybindings.json found to sync.")
            return
        
        cursor_keybindings = self.cursor_data_dir / "keybindings.json"
        cursor_keybindings.parent.mkdir(parents=True, exist_ok=True)
        
        # Copy keybindings
        with open(self.keybindings_file, 'r', encoding='utf-8') as src:
            with open(cursor_keybindings, 'w', encoding='utf-8') as dst:
                dst.write(src.read())
        
        print(f"Synced keybindings to {cursor_keybindings}")
    
    def export_current_setup(self) -> None:
        """Export current Cursor setup (extensions, settings, keybindings)."""
        print("Exporting current Cursor setup...")
        
        # Export extensions
        extensions = self.get_installed_extensions()
        if extensions:
            self.save_extensions(extensions)
        
        # Export settings
        cursor_settings = self.cursor_data_dir / "settings.json"
        if cursor_settings.exists():
            with open(cursor_settings, 'r', encoding='utf-8') as src:
                with open(self.settings_file, 'w', encoding='utf-8') as dst:
                    dst.write(src.read())
            print(f"Exported settings to {self.settings_file}")
        
        # Export keybindings
        cursor_keybindings = self.cursor_data_dir / "keybindings.json"
        if cursor_keybindings.exists():
            with open(cursor_keybindings, 'r', encoding='utf-8') as src:
                with open(self.keybindings_file, 'w', encoding='utf-8') as dst:
                    dst.write(src.read())
            print(f"Exported keybindings to {self.keybindings_file}")
        
        print("Export completed!")
    
    def import_setup(self) -> None:
        """Import and apply setup from files."""
        print("Importing Cursor setup...")
        
        # Import extensions
        extensions = self.load_extensions()
        if extensions:
            self.install_extensions(extensions)
        
        # Import settings and keybindings
        self.sync_settings()
        self.sync_keybindings()
        
        print("Import completed!")
    
    def show_status(self) -> None:
        """Show current status of extensions and settings."""
        print("=== Cursor Extensions Sync Status ===")
        
        # Show installed extensions
        installed = self.get_installed_extensions()
        print(f"\nInstalled extensions: {len(installed)}")
        for ext in sorted(installed):
            print(f"  - {ext}")
        
        # Show saved extensions
        saved = self.load_extensions()
        print(f"\nSaved extensions: {len(saved)}")
        for ext in sorted(saved):
            print(f"  - {ext}")
        
        # Show settings status
        print(f"\nSettings file: {'âœ“' if self.settings_file.exists() else 'âœ—'}")
        print(f"Keybindings file: {'âœ“' if self.keybindings_file.exists() else 'âœ—'}")


def main():
    """Main entry point."""
    sync = CursorExtensionSync()
    
    if len(sys.argv) < 2:
        print("Cursor Extensions Sync Tool")
        print("\nUsage:")
        print("  python sync_extensions.py export    - Export current setup")
        print("  python sync_extensions.py import    - Import and apply setup")
        print("  python sync_extensions.py status    - Show current status")
        print("  python sync_extensions.py help      - Show this help")
        return
    
    command = sys.argv[1].lower()
    
    if command == "export":
        sync.export_current_setup()
    elif command == "import":
        sync.import_setup()
    elif command == "status":
        sync.show_status()
    elif command == "help":
        print("Cursor Extensions Sync Tool")
        print("\nThis tool helps you sync Cursor extensions and settings across different installations.")
        print("\nCommands:")
        print("  export  - Export your current Cursor setup (extensions, settings, keybindings)")
        print("  import  - Import and apply a previously exported setup")
        print("  status  - Show the current status of your Cursor installation")
        print("  help    - Show this help message")
        print("\nFiles managed:")
        print("  extensions.txt  - List of extension IDs")
        print("  settings.json   - Cursor settings")
        print("  keybindings.json - Cursor keybindings")
    else:
        print(f"Unknown command: {command}")
        print("Use 'python sync_extensions.py help' for usage information.")


if __name__ == "__main__":
    main()
