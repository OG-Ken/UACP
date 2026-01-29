# Project Context

## 1. Operating Rules
- **Collaborative Guidance**: Work with the user to clarify ambiguities rather than making assumptions. The user relies on you for technical expertise and heavy lifting, but you must seek clarification when requirements are unclear.
- **Filesystem as Memory**: You must read before you write. Check `.ai/memory/` for active state.
- **Root Directory Purity**: NEVER create context, summary, or memory files in the project root. All such files MUST go into `.ai/memory/`.
- **Templates**: When creating files that follow established patterns, check `.ai/templates/` for guidance.
- **Organic Memory**: You are empowered to create new files in `.ai/memory/` to store persistent context (e.g., `.ai/memory/architecture_summary.md`).
- **Tmp Folder**: Use `.ai/tmp/` for experimental code, ideas, or scratchpads. Do not put production code here.

## 2. Directory Structure
- **/.ai/context.md**: This file. Your starting point and general pivot.
- **/.ai/memory/**: Active project state. READ THIS FIRST before taking action.
- **/.ai/templates/**: Patterns and examples for creating consistent files.
- **/.ai/artifacts/**: Final deliverables and generated outputs.
- **/.ai/tmp/**: Sandbox for experiments and non-production work.

## 3. Project Definition
**Name**: {{PROJECT_NAME}}
**Goal**: [Brief Description - To be filled by User or Agent]
**Status**: Initialized

## 4. Template System
When you need to create a structured file (task list, log entry, documentation), check `.ai/templates/` for existing patterns. Templates provide consistency across sessions and agents.

### Template Discovery
List available templates:
```bash
ls .ai/templates/
```

Read a specific template:
```bash
cat .ai/templates/task.md
```

## 5. Memory Management
The `.ai/memory/` directory is your persistent working memory:
- **task.md** - Current task list and status
- **context_*.md** - Domain-specific context (architecture, decisions, etc.)
- **logs/** - Session logs and change history (if needed)

Create memory files freely when they add value for future sessions.

---
*UACP v3.0 - AI-Agnostic Context Protocol*
