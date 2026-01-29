# Git Setup Commands

## Initialize Repository

```bash
# Navigate to project
cd /Users/ken/Repositories/portfolio/UACP

# Initialize git
git init

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: UACP v3.0.0 CLI tool"

# Create private repository on GitHub
# Then add remote and push:
git remote add origin <your-repo-url>
git branch -M main
git push -u origin main
```

## Files Being Tracked

### Core Files (7 files)
- `uacp` - Main CLI script (13KB)
- `install.sh` - Installation script (3KB)
- `uninstall.sh` - Uninstallation script (2KB)
- `README.md` - Project documentation (9KB)
- `DEVELOPER_GUIDE.md` - Development guide (9KB)
- `.gitignore` - Git ignore rules
- `GIT_SETUP.md` - This file (can delete after setup)

### Ignored (via .gitignore)
- `Legacy/` - Old script versions
- `test-*/` - Test directories
- `.DS_Store` - macOS files
- Editor files (*.swp, .vscode/, etc.)
- Backup files (*.bak)

## Repository Settings

After creating on GitHub:
1. Set repository to **Private**
2. Add description: "Unified Agentic Context Protocol - A filesystem-based context management system for AI agents"
3. Add topics: `ai`, `cli`, `tool`, `context-management`, `agents`

## Delete This File

After setup is complete:
```bash
rm GIT_SETUP.md
git add -u
git commit -m "Clean up setup documentation"
git push
```
