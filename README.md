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

#### One-Line Install (Recommended)

No cloning required — copy and paste one command:

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/OG-Ken/UACP/main/bootstrap.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/OG-Ken/UACP/main/bootstrap.ps1 | iex
```

The bootstrap script downloads UACP, installs it to a standard location, registers the `uacp` command, verifies the installation, and cleans up the temporary download automatically.

**Re-run the same command to update UACP to the latest version.**

---

#### Manual Install (Developer / Local Clone)

If you have cloned the repo and want a live-edit symlink:

**macOS / Linux:**
```bash
# Clone or download this repository
cd /path/to/UACP

# Install globally
bash install.sh
```

This creates a symlink: `~/.local/bin/uacp` → `<repo>/uacp`

**Windows:**

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
│   ├── claude/
│   │   └── agents/            # Claude Code sub-agents (symlinked from .claude/)
│   ├── artifacts/              # Deliverables
│   └── tmp/                    # Experiments
├── .claude -> .ai/claude/      # Symlink (keeps root clean)
├── .gitignore                  # Ignores .ai and .claude
├── claude.md                   # Pointer file (Claude-specific)
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

## Claude Agent Storage

UACP automatically keeps Claude Code's project files inside `.ai/` using a symlink. This preserves **Root Directory Purity** — no extra directories cluttering your project root.

### How It Works

When you run `uacp init`, it:
1. Creates `.ai/claude/agents/` to store project-level Claude agents
2. Creates a symlink: `.claude/` → `.ai/claude/`

Claude Code reads and writes to `.claude/` as normal — but the files actually live inside `.ai/claude/`. The root stays clean.

### Adding Claude Agents

Place agent definition `.md` files in `.ai/claude/agents/`:

```bash
# Create a custom agent for this project
nano .ai/claude/agents/my-reviewer.md

# Claude Code finds it automatically via the .claude/ symlink
```

### Migrating an Existing `.claude/` Directory

If your project already has a `.claude/` directory when you run `uacp init`, UACP will prompt you:

```
[!] Found an existing .claude directory.
    UACP can migrate its contents to .ai/claude/ and replace .claude/ with a symlink.

Migrate .claude/ → .ai/claude/ and replace with symlink? (y/n)
```

- **y**: Contents are moved, symlink is created. Everything continues working.
- **n**: `.claude/` is left untouched. Agents stay in the default location.

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

## Customizing Templates

UACP templates are stored in `templates/` directory and can be easily customized:

```bash
cd /path/to/UACP/templates
nano context.md          # Edit context template
nano pointer.md          # Edit pointer file template
```

Changes to templates affect all **new** projects initialized with `uacp init`. Existing projects keep their original files.

### Template Variables

Templates support these placeholders:
- `{{PROJECT_NAME}}` - Replaced with project name during initialization

## Privacy & Git Ignore

By default, UACP generates a `.gitignore` that **excludes the `.ai/` directory**. This keeps your development process private and your repository clean.

### Why Ignore .ai/ by Default?

1. **Privacy**: Your working context, decisions, and thought process remain local
2. **Cleaner Repos**: Focus commits on actual code, not AI context files
3. **Personal Workflow**: Different team members can maintain their own AI context
4. **Flexibility**: Easily modify if you want to share context

### Committing .ai/ Directory (Optional)

If you want to commit AI context to your repository:

```bash
# Remove .ai/ from .gitignore
sed -i '' '/^\.ai\/$/d' .gitignore

# Or manually edit .gitignore and remove the .ai/ line
nano .gitignore

# Then commit
git add .ai/
git commit -m "Add AI context to repository"
```

**Use cases for committing .ai/:**
- Team wants shared AI context and decisions
- Documentation of architectural choices
- Onboarding new team members with AI assistance

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
├── templates/              # Template files for initialization
│   ├── context.md          # Project context template
│   ├── pointer.md          # Pointer file template
│   ├── task.md             # Task list template
│   ├── session_log.md      # Session log template
│   ├── context_summary.md  # Context summary template
│   └── initial_task.md     # Initial task template
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

## Authors

OG-Ken

---

**UACP v3.3.0** - Filesystem as Memory for AI Agents
