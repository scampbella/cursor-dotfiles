#!/bin/bash

# Setup script for Cursor Extension Sync with GitHub
# This script helps initialize the GitHub repository

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

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_step "Initializing Git repository..."
    git init
    print_status "Git repository initialized"
fi

# Check if remote origin exists
if ! git remote get-url origin &> /dev/null; then
    print_warning "No GitHub remote configured yet."
    echo ""
    echo "To connect to your GitHub repository 'cursor-dotfiles', run:"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/cursor-dotfiles.git"
    echo ""
    echo "Replace YOUR_USERNAME with your actual GitHub username."
    echo ""
    read -p "Enter your GitHub username: " github_username
    
    if [ -n "$github_username" ]; then
        git remote add origin "https://github.com/$github_username/cursor-dotfiles.git"
        print_status "GitHub remote added: https://github.com/$github_username/cursor-dotfiles.git"
    else
        print_warning "No username provided. You'll need to add the remote manually."
    fi
fi

# Add all files to git
print_step "Adding files to Git..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    print_warning "No changes to commit. Repository is up to date."
else
    print_step "Committing initial configuration..."
    git commit -m "Initial Cursor extension sync setup"
    print_status "Files committed to Git"
fi

# Push to GitHub
print_step "Pushing to GitHub..."
if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
    print_status "Successfully pushed to GitHub!"
else
    print_warning "Failed to push to GitHub. You may need to:"
    echo "1. Create the repository on GitHub first"
    echo "2. Set up authentication (SSH keys or personal access token)"
    echo "3. Check your internet connection"
fi

echo ""
print_status "Setup complete! Here's what to do next:"
echo ""
echo "1. Export your current Cursor configuration:"
echo "   ./sync-extensions.sh export"
echo ""
echo "2. Commit and push the exported configuration:"
echo "   git add ."
echo "   git commit -m 'Export Cursor configuration'"
echo "   git push"
echo ""
echo "3. On your Windows PC, clone the repository and import:"
echo "   git clone https://github.com/$github_username/cursor-dotfiles.git"
echo "   cd cursor-dotfiles"
echo "   sync-extensions.bat import"
echo ""
print_status "Happy coding! 🚀"
