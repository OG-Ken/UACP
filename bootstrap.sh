#!/bin/bash

################################################################################
# UACP Bootstrap - One-line remote installer
#
# Usage (macOS / Linux):
#   curl -fsSL https://raw.githubusercontent.com/OG-Ken/UACP/main/bootstrap.sh | bash
#
# This script:
#   1. Checks prerequisites (git, bash)
#   2. Downloads UACP to a temporary directory
#   3. Copies files to a permanent install location (~/.local/share/uacp)
#   4. Runs install.sh to create the global 'uacp' symlink
#   5. Verifies the installation
#   6. Cleans up the temporary download
#
# Re-running this script will update UACP to the latest version.
################################################################################

set -e

REPO_URL="https://github.com/OG-Ken/UACP.git"
INSTALL_DIR="$HOME/.local/share/uacp"
TEMP_DIR=""

# ----------------------------------------------------------------------------
# Cleanup: remove temp dir on exit (success or failure)
# ----------------------------------------------------------------------------
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        echo "  ✓ Temporary files cleaned up"
    fi
}
trap cleanup EXIT

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  UACP Bootstrap Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ----------------------------------------------------------------------------
# Step 1: Check prerequisites
# ----------------------------------------------------------------------------
echo "[1/5] Checking prerequisites..."

if ! command -v git &>/dev/null; then
    echo "  ❌ Error: git is required but not found."
    echo "     Install git: https://git-scm.com/downloads"
    exit 1
fi
echo "  ✓ git found: $(git --version)"

if ! command -v bash &>/dev/null; then
    echo "  ❌ Error: bash is required but not found."
    exit 1
fi
echo "  ✓ bash found: $(bash --version | head -1)"

# ----------------------------------------------------------------------------
# Step 2: Download UACP to a temp directory
# ----------------------------------------------------------------------------
echo ""
echo "[2/5] Downloading UACP..."

TEMP_DIR=$(mktemp -d)
git clone --depth=1 --quiet "$REPO_URL" "$TEMP_DIR/uacp"
echo "  ✓ Downloaded to temporary location"

# Extract version for display
VERSION=$(grep "^UACP_VERSION=" "$TEMP_DIR/uacp/uacp" | cut -d'"' -f2)
echo "  ✓ Version: $VERSION"

# ----------------------------------------------------------------------------
# Step 3: Copy files to permanent install location
# ----------------------------------------------------------------------------
echo ""
echo "[3/5] Installing to $INSTALL_DIR..."

mkdir -p "$INSTALL_DIR"

# Copy core files
cp "$TEMP_DIR/uacp/uacp"         "$INSTALL_DIR/uacp"
cp "$TEMP_DIR/uacp/install.sh"   "$INSTALL_DIR/install.sh"
cp "$TEMP_DIR/uacp/uninstall.sh" "$INSTALL_DIR/uninstall.sh"

# Copy templates directory (overwrite for updates)
rm -rf "$INSTALL_DIR/templates"
cp -r "$TEMP_DIR/uacp/templates" "$INSTALL_DIR/templates"

# Make scripts executable
chmod +x "$INSTALL_DIR/uacp"
chmod +x "$INSTALL_DIR/install.sh"
chmod +x "$INSTALL_DIR/uninstall.sh"

echo "  ✓ Files installed to $INSTALL_DIR"

# ----------------------------------------------------------------------------
# Step 4: Run install.sh to create the global 'uacp' symlink
# ----------------------------------------------------------------------------
echo ""
echo "[4/5] Registering 'uacp' command..."
echo ""

bash "$INSTALL_DIR/install.sh"

# ----------------------------------------------------------------------------
# Step 5: Verify the installation
# ----------------------------------------------------------------------------
echo ""
echo "[5/5] Verifying installation..."

# Source common shell configs to pick up new PATH entries
if [ -f "$HOME/.zshrc" ]; then
    # shellcheck disable=SC1091
    source "$HOME/.zshrc" 2>/dev/null || true
fi
if [ -f "$HOME/.bashrc" ]; then
    # shellcheck disable=SC1091
    source "$HOME/.bashrc" 2>/dev/null || true
fi

if command -v uacp &>/dev/null; then
    echo "  ✓ 'uacp' command is accessible"
    echo ""
    uacp version
else
    echo "  ⚠️  'uacp' not in PATH yet."
    echo "     To activate, run one of the following:"
    echo "       source ~/.zshrc    (zsh)"
    echo "       source ~/.bashrc   (bash)"
    echo "     Or restart your terminal."
fi

# Temp dir is removed by the cleanup trap

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ Bootstrap Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "UACP is installed at: $INSTALL_DIR"
echo ""
echo "To update UACP later, re-run this bootstrap command."
echo "To uninstall: bash $INSTALL_DIR/uninstall.sh"
echo ""
