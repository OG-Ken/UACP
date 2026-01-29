# UACP - Unified Agentic Context Protocol

A filesystem-based context management system for AI agents. UACP provides a standardized structure for AI agents to maintain persistent memory, follow consistent patterns, and collaborate effectively across sessions.

## Philosophy

AI agents work best when they have:
- **Persistent Memory**: A place to store context across sessions
- **Clear Rules**: Guidelines on what to do and what not to do
- **Collaborative Guidance**: Balance between autonomy and seeking clarification
- **Root Directory Purity**: Keep project roots clean, store context in designated locations

UACP provides this structure through a simple `.ai/` directory and pointer files.

## Features

- 🚀 **Global CLI Tool**: Install once, use anywhere with `uacp` command
- 🔄 **Auto-Updates**: Symlink-based installation means edits are instantly available
- 🎯 **AI-Agnostic**: Works with Claude, Gemini, GPT, or any AI assistant
- 📁 **Clean Structure**: All agent context in `.ai/` directory
- 📝 **Template System**: Consistent file formats across projects
- 🔧 **Modular & Extensible**: Easy to add new commands
- 🎨 **Flexible Syntax**: Supports both `uacp init` and `uacp -init` styles

## Quick Start

### Installation

#### macOS / Linux

```bash
# Clone or download this repository
cd /path/to/UACP

# Install globally
bash install.sh
```

This creates a symlink: `~/.local/bin/uacp` → `<repo>/uacp`

#### Windows

**Prerequisites**: Git Bash must be installed ([Download here](https://git-scm.com/downloads))

```powershell
# Clone or download this repository
cd path\to\UACP

# Install PowerShell module
.\install.ps1
```

This creates a PowerShell module in: `Documents\PowerShell\Modules\UACP`

### Initialize a Project

```bash
# Navigate to your project
cd ~/my-awesome-project

# Initialize UACP
uacp init "MyProject"

# Or use directory name as project name
uacp init
```

### What Gets Created

```
my-awesome-project/
├── .ai/
│   ├── context.md              # Project rules and structure
│   ├── memory/
│   │   └── task.md            # Active tasks and state
│   ├── templates/
│   │   ├── task.md            # Task list template
│   │   ├── session_log.md     # Logging template
│   │   └── context_summary.md # Summary template
│   ├── artifacts/              # Deliverables
│   └── tmp/                    # Experiments
├── .gitignore                  # Ignores .ai/tmp/
├── claude.md                   # Pointer file
├── gemini.md                   # Pointer file
├── agents.md                   # Pointer file
└── open-code.md                # Pointer file
```

## How It Works

### Pointer Files

When an AI agent reads `claude.md`, `gemini.md`, or any pointer file, it's redirected to read:
1. `.ai/context.md` - Project rules and structure
2. `.ai/memory/task.md` - Current tasks and state
3. `.ai/templates/` - Patterns for creating files

All pointer files contain the same AI-agnostic instructions.

### Context File

`.ai/context.md` contains:
- **Operating Rules**: Collaborative guidance, filesystem as memory, root directory purity
- **Directory Structure**: Explanation of what goes where
- **Project Definition**: Name, goal, status
- **Template System**: How to discover and use templates
- **Memory Management**: Guidelines for persistent context

### Memory Directory

`.ai/memory/` is where agents store:
- `task.md` - Current task list
- `architecture.md` - System architecture notes
- `decisions.md` - Key decisions and rationale
- `session_*.md` - Session logs
- Any other persistent context

## Available Commands

### Core Commands

```bash
uacp init [name]           # Initialize UACP in current directory
uacp init -claudeonly      # Create only claude.md pointer
uacp version               # Show version information
uacp help                  # Show help message
```

### Command Styles

Both styles are supported:
```bash
uacp init "MyProject"      # Subcommand style (recommended)
uacp -init "MyProject"     # Flag style (backwards compatible)
```

## Usage Examples

### Basic Initialization
```bash
cd ~/new-project
uacp init "NewProject"
```

### Claude-Only Mode
For projects that only use Claude:
```bash
uacp init "ClaudeProject" -claudeonly
```

### Check Version
```bash
uacp version
```

### View Help
```bash
uacp help
```

## Development

### Architecture

The CLI is built with a modular architecture:

```
uacp script
├── Configuration (version, directory names)
├── Helper Functions (error, success, info)
├── Command Functions (self-contained)
│   ├── cmd_init()
│   ├── cmd_version()
│   └── [Add new commands here]
├── Argument Parser
└── Main Execution
```

### Adding New Commands

Adding a command takes 3 simple steps:

1. **Create command function** in the "COMMAND FUNCTIONS" section
2. **Add case** to `parse_arguments()` function
3. **Update help text** in `show_help()` function

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for detailed examples and patterns.

### Live Development

Because the command is symlinked (not copied), changes are instant:

```bash
# Edit the script
nano uacp

# Test immediately (no reinstall needed!)
uacp version
```

The symlink means `~/.local/bin/uacp` always points to your repo's `uacp` file.

## Project Structure

```
UACP/
├── uacp                    # Main CLI script (modular, extensible)
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── DEVELOPER_GUIDE.md      # Detailed guide for adding commands
├── README.md               # This file
├── .gitignore              # Git ignore rules
└── Legacy/                 # Old versions (not tracked)
```

## Operating Rules

UACP enforces these principles:

### 1. Collaborative Guidance
Work with the user to clarify ambiguities rather than making assumptions. The user relies on you for technical expertise, but you must seek clarification when requirements are unclear.

### 2. Filesystem as Memory
Read before you write. Always check `.ai/memory/` for existing context and state before taking action.

### 3. Root Directory Purity
NEVER create context, summary, or memory files in the project root. All such files MUST go into `.ai/memory/`.

### 4. Template-Guided Consistency
When creating structured files, check `.ai/templates/` for existing patterns.

### 5. Organic Memory Creation
Agents are empowered to create new files in `.ai/memory/` when they add value for future sessions.

## Uninstallation

### macOS / Linux
```bash
cd /path/to/UACP
bash uninstall.sh
```

### Windows
```powershell
cd path\to\UACP
.\uninstall.ps1
```

Source files in the repo are preserved - only the command/module is removed.

## Use Cases

### Personal Projects
Keep AI agents aligned across sessions:
```bash
cd ~/personal-project
uacp init
# Agent now has persistent memory and clear guidelines
```

### Team Collaboration
Standardize AI interaction patterns:
```bash
cd ~/team-project
uacp init "TeamProject"
git add .ai/ *.md .gitignore
git commit -m "Add UACP structure"
# Team members' AI agents follow same patterns
```

### Client Work
Maintain context for long-running projects:
```bash
cd ~/client-project
uacp init "ClientName"
# AI remembers architecture decisions, constraints, preferences
```

## Requirements

### macOS / Linux
- **Shell**: bash or zsh
- **PATH**: `~/.local/bin` should be in your PATH (install script checks this)

### Windows
- **Git Bash**: Required ([Download here](https://git-scm.com/downloads))
- **PowerShell**: Version 5.1 or later (included with Windows 10+)

## Roadmap

Future commands planned:
- `uacp verify` - Check UACP structure integrity
- `uacp context -nano` - Open context.md for editing
- `uacp upgrade` - Update to latest version
- `uacp status` - Show project information
- `uacp clean` - Clean temporary files

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for implementation examples.

## Philosophy: Why UACP?

AI agents are powerful but stateless. Between sessions, they forget:
- What was the architecture decision?
- What tasks are in progress?
- What constraints exist?
- What patterns should be followed?

UACP solves this by:
1. **Filesystem as Memory**: Persistent context stored in `.ai/`
2. **Pointer Files**: Quick entry points for any AI
3. **Template System**: Consistent patterns across sessions
4. **Clear Rules**: Guidelines that prevent common mistakes

The result: AI agents that remember, follow patterns, and collaborate effectively.

## Contributing

This is currently a private repository for personal use. If you have access and want to contribute:

1. Create a new branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for development guidelines.

## License

Private - All Rights Reserved

## Author

Ken

---

**UACP v3.0.0** - Filesystem as Memory for AI Agents
