# UACP Developer Guide

## Quick Start

### Installation
```bash
bash install.sh    # Install uacp command globally
bash uninstall.sh  # Remove uacp command
```

### Testing Changes
Since the command is symlinked to your repo, **any changes you make to the `uacp` script are immediately available**:

```bash
# Edit the script
nano uacp

# Test immediately (no reinstall needed)
uacp version
```

## Architecture Overview

The `uacp` script is modular and designed for easy extension:

```
uacp
├── Configuration (lines 11-15)
├── Helper Functions (lines 20-67)
├── Command Functions (lines 73+)
│   ├── cmd_init()
│   ├── cmd_version()
│   └── [Add new commands here]
├── Argument Parser (lines 500+)
└── Main Execution (lines 550+)
```

## Adding a New Command

### Step 1: Create the Command Function

Add a new function in the "COMMAND FUNCTIONS" section:

```bash
# ----------------------------------------------------------------------------
# Command: yourcommand
# Brief description of what it does
# ----------------------------------------------------------------------------
cmd_yourcommand() {
    local option1=""
    local option2=""

    # Parse arguments for this command
    while [[ $# -gt 0 ]]; do
        case $1 in
            -flag1)
                option1="value1"
                shift
                ;;
            -flag2)
                option2="$2"
                shift 2
                ;;
            -*)
                error "Unknown option for yourcommand: $1"
                ;;
            *)
                error "Unexpected argument: $1"
                ;;
        esac
    done

    # Your command logic here
    info "Executing yourcommand..."
    success "Command completed!"
}
```

### Step 2: Add to Argument Parser

Update the `parse_arguments()` function:

```bash
parse_arguments() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    case $1 in
        init)
            shift
            cmd_init "$@"
            ;;
        yourcommand)          # Add this
            shift             # Add this
            cmd_yourcommand "$@"  # Add this
            ;;                # Add this
        version|--version|-v)
            cmd_version
            ;;
        # ... rest of cases
    esac
}
```

### Step 3: Update Help Text

Add your command to `show_help()`:

```bash
COMMANDS:
    init [project_name]         Initialize UACP in current directory
    yourcommand [options]       Description of your command
    version                     Show version information
    help                        Show this help message
```

### Step 4: Test

```bash
uacp yourcommand
uacp yourcommand -flag1
```

That's it! Three simple steps to add any new command.

## Real-World Examples

### Example 1: Simple Command (verify)

Check integrity of UACP structure:

```bash
# ----------------------------------------------------------------------------
# Command: verify
# Verify UACP structure integrity
# ----------------------------------------------------------------------------
cmd_verify() {
    info "Verifying UACP structure..."

    # Check if .ai exists
    if [ ! -d "$UACP_DIR" ]; then
        error "UACP not initialized (no $UACP_DIR directory)"
    fi

    # Check core files
    local missing=0

    if [ ! -f "$UACP_DIR/context.md" ]; then
        echo "✗ Missing: $UACP_DIR/context.md"
        missing=$((missing + 1))
    else
        success "Found: $UACP_DIR/context.md"
    fi

    if [ ! -f "$UACP_DIR/memory/task.md" ]; then
        echo "✗ Missing: $UACP_DIR/memory/task.md"
        missing=$((missing + 1))
    else
        success "Found: $UACP_DIR/memory/task.md"
    fi

    if [ $missing -eq 0 ]; then
        echo ""
        success "UACP structure is valid!"
    else
        echo ""
        error "UACP structure has $missing missing files"
    fi
}
```

### Example 2: Command with Options (context)

Open context.md in an editor:

```bash
# ----------------------------------------------------------------------------
# Command: context
# Open context.md for editing
# ----------------------------------------------------------------------------
cmd_context() {
    local editor="nano"  # Default editor

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -nano)
                editor="nano"
                shift
                ;;
            -vim)
                editor="vim"
                shift
                ;;
            -code)
                editor="code"
                shift
                ;;
            -*)
                error "Unknown option for context: $1"
                ;;
            *)
                error "Unexpected argument: $1"
                ;;
        esac
    done

    # Check if file exists
    if [ ! -f "$UACP_DIR/context.md" ]; then
        error "context.md not found. Run 'uacp init' first."
    fi

    # Open in editor
    info "Opening context.md in $editor..."
    $editor "$UACP_DIR/context.md"
}
```

### Example 3: Command with File Operations (upgrade)

Update from local repository:

```bash
# ----------------------------------------------------------------------------
# Command: upgrade
# Upgrade UACP to latest version from local repo
# ----------------------------------------------------------------------------
cmd_upgrade() {
    local script_path
    script_path=$(readlink "$0" || echo "$0")
    local repo_dir
    repo_dir=$(dirname "$script_path")

    info "Upgrading UACP from: $repo_dir"

    # Check if we're running from a symlink
    if [ ! -L "$0" ]; then
        error "Not running from installed location. Run install.sh first."
    fi

    # Show current version
    info "Current version: $UACP_VERSION"

    # The symlink automatically points to latest, so just confirm
    success "Already running latest version (symlink auto-updates)"

    # Optionally show what would be updated
    info ""
    info "The 'uacp' command is symlinked to:"
    info "  $script_path"
    info ""
    info "Any changes you make to that file are immediately available."
}
```

## Helper Functions

Use these built-in helpers in your commands:

```bash
error "message"     # Print error and exit
success "message"   # Print success (with ✓)
info "message"      # Print info message
```

## Configuration Variables

Available throughout the script:

```bash
$UACP_VERSION      # Current version (e.g., "3.0.0")
$UACP_DIR          # Directory name (e.g., ".ai")
```

## Testing Your Changes

1. **Edit the script**:
   ```bash
   nano uacp
   ```

2. **Test immediately** (symlink means no reinstall needed):
   ```bash
   uacp yourcommand
   ```

3. **Debug with bash -x**:
   ```bash
   bash -x $(which uacp) yourcommand
   ```

## Command Design Principles

1. **Self-contained**: Each command function should be independent
2. **Parse options early**: Handle all flags at the start of the function
3. **Validate inputs**: Check for required files/directories
4. **Clear output**: Use success/info/error helpers for consistency
5. **Fail gracefully**: Use `error()` to exit with helpful messages

## Common Patterns

### Check if UACP is initialized
```bash
if [ ! -d "$UACP_DIR" ]; then
    error "UACP not initialized. Run 'uacp init' first."
fi
```

### Parse boolean flags
```bash
local verbose=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            verbose=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if [ "$verbose" = true ]; then
    info "Verbose mode enabled"
fi
```

### Parse value flags
```bash
local output_file=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done
```

## Next Commands to Implement

Based on the user's requests:

1. **verify** - Check UACP structure integrity
2. **context** - Open context.md with `-nano`, `-vim`, `-code` options
3. **upgrade** - Update from local repository
4. **status** - Show current UACP status (project name, version, file counts)
5. **clean** - Clean tmp/ directory
6. **export** - Export UACP structure to archive

## Troubleshooting

### Command not found after editing
- The symlink might be broken
- Run `bash install.sh` again

### Changes not taking effect
- Make sure you're editing the right file: `which uacp` shows the symlink
- Use `readlink $(which uacp)` to find the actual file

### Syntax errors
- Test with: `bash -n uacp` (checks syntax without running)
- Debug with: `bash -x uacp yourcommand` (shows execution trace)

## File Locations

- **Script source**: `/Users/ken/Repositories/portfolio/UACP/uacp`
- **Symlink**: `~/.local/bin/uacp`
- **Install script**: `/Users/ken/Repositories/portfolio/UACP/install.sh`
- **Uninstall script**: `/Users/ken/Repositories/portfolio/UACP/uninstall.sh`

## Versioning

Update version in the script header:

```bash
UACP_VERSION="3.1.0"  # Update this line
```

Users can check version with: `uacp version`
