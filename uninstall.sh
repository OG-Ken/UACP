#!/bin/bash

# UACP Uninstallation Script
# Removes the 'uacp' command symlink

set -e  # Exit on error

INSTALL_DIR="$HOME/.local/bin"
COMMAND_NAME="uacp"
SYMLINK_PATH="$INSTALL_DIR/$COMMAND_NAME"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  UACP Uninstallation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if symlink exists
if [ ! -L "$SYMLINK_PATH" ]; then
    if [ -f "$SYMLINK_PATH" ]; then
        echo "⚠️  Warning: $SYMLINK_PATH exists but is not a symlink."
        echo "   Please remove it manually if you want to uninstall."
        exit 1
    else
        echo "✓ UACP is not installed (symlink not found)"
        echo "  Looked in: $SYMLINK_PATH"
        exit 0
    fi
fi

# Show what will be removed
echo "The following symlink will be removed:"
echo "  $SYMLINK_PATH"
echo ""

# Confirm
read -p "Continue with uninstallation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove symlink
echo ""
echo "Removing symlink..."
rm "$SYMLINK_PATH"
echo "✓ Removed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Uninstallation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The 'uacp' command has been removed."
echo ""
echo "Note: The source files in this directory were NOT removed."
echo "      Only the global command symlink was deleted."
echo ""
echo "To reinstall:"
echo "  bash install.sh"
echo ""
