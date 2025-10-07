#!/bin/bash

# Script to find where Cursor actually stores its extensions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_step "Searching for Cursor extensions directories..."

# Check various possible locations
LOCATIONS=(
    "$HOME/Library/Application Support/Cursor/User/extensions"
    "$HOME/.vscode/extensions"
    "$HOME/Library/Application Support/Cursor/extensions"
    "$HOME/.cursor/extensions"
    "$HOME/Library/Application Support/Cursor/User/globalStorage"
)

FOUND_LOCATIONS=()

for location in "${LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        extension_count=$(find "$location" -maxdepth 1 -type d | wc -l)
        extension_count=$((extension_count - 1)) # Subtract 1 for the directory itself
        if [ $extension_count -gt 0 ]; then
            print_status "Found $extension_count extensions in: $location"
            FOUND_LOCATIONS+=("$location")
            
            # Show some example extensions
            echo "  Sample extensions:"
            find "$location" -maxdepth 1 -type d -name "*" | head -5 | while read dir; do
                if [ "$dir" != "$location" ]; then
                    basename_dir=$(basename "$dir")
                    echo "    - $basename_dir"
                fi
            done
            echo
        fi
    fi
done

if [ ${#FOUND_LOCATIONS[@]} -eq 0 ]; then
    print_warning "No extensions directories found in common locations"
    print_step "Let's search more broadly..."
    
    # Search for any directories containing "extension" in the Cursor app support
    find "$HOME/Library/Application Support/Cursor" -name "*extension*" -type d 2>/dev/null | while read dir; do
        if [ -d "$dir" ]; then
            extension_count=$(find "$dir" -maxdepth 1 -type d | wc -l)
            extension_count=$((extension_count - 1))
            if [ $extension_count -gt 0 ]; then
                print_status "Found $extension_count items in: $dir"
                find "$dir" -maxdepth 1 -type d -name "*" | head -3 | while read subdir; do
                    if [ "$subdir" != "$dir" ]; then
                        basename_subdir=$(basename "$subdir")
                        echo "    - $basename_subdir"
                    fi
                done
                echo
            fi
        fi
    done
fi

print_step "Checking for specific extensions you mentioned..."

# Look for synthwave and spotify extensions
SYNTHWAVE_FOUND=false
SPOTIFY_FOUND=false

for location in "${FOUND_LOCATIONS[@]}"; do
    if find "$location" -name "*synthwave*" -o -name "*84*" | grep -q .; then
        print_status "Found Synthwave '84 extension in: $location"
        SYNTHWAVE_FOUND=true
    fi
    
    if find "$location" -name "*spotify*" | grep -q .; then
        print_status "Found Spotify extension in: $location"
        SPOTIFY_FOUND=true
    fi
done

if [ "$SYNTHWAVE_FOUND" = false ]; then
    print_warning "Synthwave '84 extension not found in any location"
fi

if [ "$SPOTIFY_FOUND" = false ]; then
    print_warning "Spotify extension not found in any location"
fi

print_step "Recommendations:"
echo "1. If you found extensions in a different location, we need to update the sync script"
echo "2. If extensions aren't found, they might be installed but not in the expected directory"
echo "3. Try opening Cursor and checking the Extensions panel to see what's actually installed"
echo "4. We can then update the sync script to use the correct directory"
