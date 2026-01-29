#!/bin/bash

# UACP Installation Script
# Installs the 'uacp' command globally via symlink
# Supports PowerShell mode for Windows integration

set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="$HOME/.local/bin"
COMMAND_NAME="uacp"
SOURCE_SCRIPT="$SCRIPT_DIR/$COMMAND_NAME"

# PowerShell mode - output configuration data as JSON
if [ "$1" == "-powershell" ]; then
    # Extract version from uacp script
    VERSION=$(grep "^UACP_VERSION=" "$SOURCE_SCRIPT" | cut -d'"' -f2)

    # Output JSON configuration for PowerShell
    cat <<EOF
{
  "ScriptDir": "$SCRIPT_DIR",
  "TemplateDir": "$SCRIPT_DIR/templates",
  "Version": "$VERSION",
  "UACPDir": ".ai",
  "CommandName": "uacp",
  "BashScript": "$SOURCE_SCRIPT"
}
EOF
    exit 0
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  UACP Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Check if ~/.local/bin exists, create if not
if [ ! -d "$INSTALL_DIR" ]; then
    echo "[1/5] Creating $INSTALL_DIR directory..."
    mkdir -p "$INSTALL_DIR"
    echo "      ✓ Created"
else
    echo "[1/5] Install directory exists: $INSTALL_DIR"
fi

# 2. Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "[2/5] ⚠️  WARNING: $INSTALL_DIR is not in your PATH"
    echo "      Add this to your ~/.zshrc:"
    echo "      export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    read -p "      Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "      Installation cancelled."
        exit 1
    fi
else
    echo "[2/5] ✓ Install directory is in PATH"
fi

# 3. Copy uacp_init.sh to uacp (main script)
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "[3/5] Creating main 'uacp' script from uacp_init.sh..."
    cp "$SCRIPT_DIR/uacp_init.sh" "$SOURCE_SCRIPT"
    echo "      ✓ Created"
else
    echo "[3/5] Main script already exists: $SOURCE_SCRIPT"
fi

# 4. Make executable
echo "[4/5] Making script executable..."
chmod +x "$SOURCE_SCRIPT"
echo "      ✓ Done"

# 5. Create symlink
SYMLINK_PATH="$INSTALL_DIR/$COMMAND_NAME"

if [ -L "$SYMLINK_PATH" ]; then
    echo "[5/5] Symlink already exists, updating..."
    rm "$SYMLINK_PATH"
    ln -s "$SOURCE_SCRIPT" "$SYMLINK_PATH"
    echo "      ✓ Updated"
elif [ -f "$SYMLINK_PATH" ]; then
    echo "[5/5] ⚠️  WARNING: A file named '$COMMAND_NAME' already exists in $INSTALL_DIR"
    echo "      This is not a symlink. Please remove it manually."
    exit 1
else
    echo "[5/5] Creating symlink..."
    ln -s "$SOURCE_SCRIPT" "$SYMLINK_PATH"
    echo "      ✓ Created"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Installation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The 'uacp' command is now available globally."
echo ""
echo "Symlink created:"
echo "  $SYMLINK_PATH → $SOURCE_SCRIPT"
echo ""
echo "Try it out:"
echo "  uacp --version"
echo "  uacp --help"
echo "  uacp init"
echo ""
echo "To uninstall:"
echo "  bash $SCRIPT_DIR/uninstall.sh"
echo ""

# Verify installation
if command -v uacp &> /dev/null; then
    echo "✓ Verified: 'uacp' command is accessible"
else
    echo "⚠️  Note: You may need to restart your terminal or run:"
    echo "   source ~/.zshrc"
fi
echo ""
