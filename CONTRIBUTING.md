# Contributing to UACP

## Branch Protection & Workflow

This repository follows best practices for version control:

### Branch Strategy

- **main** - Production-ready code only
- **feature/** - New features (e.g., `feature/new-command`)
- **bugfix/** - Bug fixes (e.g., `bugfix/template-loading`)
- **docs/** - Documentation updates (e.g., `docs/update-readme`)

### Workflow

1. **Create a branch** from main:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** and commit:
   ```bash
   git add .
   git commit -m "feat: description of changes"
   ```

3. **Push your branch**:
   ```bash
   git push -u origin feature/your-feature-name
   ```

4. **Create a Pull Request**:
   ```bash
   gh pr create --title "feat: Your Feature" --body "Description"
   ```

5. **Review and merge** after approval

### Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add verify command to check UACP structure
fix: resolve symlink path issue for templates
docs: update README with new template system
```

### Version Numbering

UACP follows [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`

- **MAJOR** (x.0.0) - Breaking changes
- **MINOR** (0.x.0) - New features (backwards compatible)
- **PATCH** (0.0.x) - Bug fixes (backwards compatible)

When incrementing version:
1. Update `UACP_VERSION` in the `uacp` script
2. Document changes in commit message
3. Tag the release after merging to main

### Branch Protection (Note)

**Important**: GitHub requires Pro subscription for branch protection on private repositories.

While we cannot technically enforce these rules, please **voluntarily follow this workflow**:
- ❌ **Never commit directly to main**
- ✅ **Always use feature branches**
- ✅ **Always create pull requests**
- ✅ **Review your own PRs before merging** (yes, even if you're the only contributor)

This practice:
- Creates a clear history of changes
- Makes rollbacks easier
- Documents decisions through PR descriptions
- Maintains professional standards

### Code Review Checklist

Before merging your PR, verify:

- [ ] Version number updated (if applicable)
- [ ] Tests pass (run `uacp init` in a test directory)
- [ ] Documentation updated (README, DEVELOPER_GUIDE)
- [ ] Commit messages follow conventions
- [ ] No debug code or console.logs left in
- [ ] Templates work correctly
- [ ] Backward compatibility maintained

### Testing Changes

Always test before creating a PR:

```bash
# Test the init command
rm -rf /tmp/uacp-test
mkdir /tmp/uacp-test
cd /tmp/uacp-test
uacp init "TestProject"

# Verify created structure
ls -la .ai/
cat .ai/context.md
cat .gitignore
```

## Development Setup

1. **Fork or clone** the repository
2. **Install UACP** locally:
   ```bash
   cd /path/to/UACP
   bash install.sh
   ```
3. **Make changes** to the `uacp` script or templates
4. **Test immediately** (symlink means changes are live)
5. **Create PR** when ready

## File Structure

```
UACP/
├── uacp                    # Main script
├── install.sh              # Installation
├── uninstall.sh            # Uninstallation
├── templates/              # Template files (easily editable)
├── README.md               # User documentation
├── DEVELOPER_GUIDE.md      # Developer documentation
└── CONTRIBUTING.md         # This file
```

## Questions or Issues?

- Check [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for implementation details
- Check [README.md](README.md) for usage information
- Open an issue on GitHub for bugs or feature requests

---

Thank you for contributing to UACP! 🚀
