#!/bin/bash

# Cursor Extension Sync Script for Mac/Linux
# This script exports and imports Cursor extensions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    CURSOR_CONFIG_DIR="$HOME/Library/Application Support/Cursor"
    CURSOR_EXTENSIONS_DIR="$HOME/.vscode/extensions"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    CURSOR_CONFIG_DIR="$HOME/.config/Cursor"
    CURSOR_EXTENSIONS_DIR="$HOME/.vscode/extensions"
else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Check if Cursor is installed
if [ ! -d "$CURSOR_CONFIG_DIR" ]; then
    print_error "Cursor configuration directory not found at: $CURSOR_CONFIG_DIR"
    print_error "Please make sure Cursor is installed and has been run at least once."
    exit 1
fi

# Function to export extensions
export_extensions() {
    print_status "Exporting Cursor extensions..."
    
    # Create extensions directory if it doesn't exist
    mkdir -p extensions
    
    # Copy extensions folder
    if [ -d "$CURSOR_EXTENSIONS_DIR" ]; then
        cp -r "$CURSOR_EXTENSIONS_DIR"/* extensions/ 2>/dev/null || true
        print_status "Extensions exported to ./extensions/"
    else
        print_warning "No extensions found to export"
    fi
    
    # Export settings
    if [ -f "$CURSOR_CONFIG_DIR/User/settings.json" ]; then
        cp "$CURSOR_CONFIG_DIR/User/settings.json" settings.json
        print_status "Settings exported to ./settings.json"
    else
        print_warning "No settings.json found"
    fi
    
    # Export keybindings
    if [ -f "$CURSOR_CONFIG_DIR/User/keybindings.json" ]; then
        cp "$CURSOR_CONFIG_DIR/User/keybindings.json" keybindings.json
        print_status "Keybindings exported to ./keybindings.json"
    else
        print_warning "No keybindings.json found"
    fi
    
    # Create extensions list
    if [ -d "extensions" ]; then
        find extensions -maxdepth 1 -type d -name "*" | sed 's|extensions/||' | grep -v "^extensions$" > extensions-list.txt
        print_status "Extensions list created: extensions-list.txt"
    fi
    
    print_status "Export completed!"
}

# Function to import extensions
import_extensions() {
    print_status "Importing Cursor extensions..."
    
    # Create Cursor config directory if it doesn't exist
    mkdir -p "$CURSOR_CONFIG_DIR/User"
    
    # Import extensions
    if [ -d "extensions" ]; then
        mkdir -p "$CURSOR_EXTENSIONS_DIR"
        cp -r extensions/* "$CURSOR_EXTENSIONS_DIR/" 2>/dev/null || true
        print_status "Extensions imported from ./extensions/"
    else
        print_warning "No extensions directory found to import"
    fi
    
    # Import settings
    if [ -f "settings.json" ]; then
        cp settings.json "$CURSOR_CONFIG_DIR/User/settings.json"
        print_status "Settings imported from ./settings.json"
    else
        print_warning "No settings.json found to import"
    fi
    
    # Import keybindings
    if [ -f "keybindings.json" ]; then
        cp keybindings.json "$CURSOR_CONFIG_DIR/User/keybindings.json"
        print_status "Keybindings imported from ./keybindings.json"
    else
        print_warning "No keybindings.json found to import"
    fi
    
    print_status "Import completed!"
    print_warning "Please restart Cursor for changes to take effect."
}

# Function to show help
show_help() {
    echo "Cursor Extension Sync Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  export    Export extensions and settings from Cursor"
    echo "  import    Import extensions and settings to Cursor"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 export    # Export current Cursor configuration"
    echo "  $0 import    # Import configuration to Cursor"
}

# Main script logic
case "${1:-}" in
    "export")
        export_extensions
        ;;
    "import")
        import_extensions
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    "")
        print_error "No command specified"
        show_help
        exit 1
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
