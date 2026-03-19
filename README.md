# 🛠️ Tooling

Personal dev tooling — Claude Code commands, scripts, and configs.

## Claude Code Commands

Custom slash commands for Claude Code. Install by copying to `~/.claude/commands/`.

| Command | Description |
|---------|-------------|
| [`/review-walk`](claude-code/commands/review-walk.md) | Interactive guided code review — walks you through a PR chunk by chunk like a story. Supports tmux side-panel diffs. |

### Install

```bash
# All commands at once
cp claude-code/commands/*.md ~/.claude/commands/

# Or just one
cp claude-code/commands/review-walk.md ~/.claude/commands/
```

### Usage

```bash
cl  # or: claude
/review-walk main..feature-branch
/review-walk 27          # PR number
/review-walk HEAD~5      # last 5 commits
```

**Pro tip:** Run inside tmux for side-by-side diffs in a separate pane:
```bash
tmux
cl
/review-walk main..feature-branch
```

## Scripts

| Script | Description |
|--------|-------------|
| [`setup-claude-code.sh`](scripts/setup-claude-code.sh) | Portable Claude Code environment setup for new laptops |
| [`agent-matrix.sh`](scripts/agent-matrix.sh) | 3x3 cyberpunk iTerm2 matrix — color-coded panes per project |
| [`agent-desktop.sh`](scripts/agent-desktop.sh) | iTerm2 tab launcher — one tab per project |

## CLI Tools Reference

See [CLI-TOOLS.md](CLI-TOOLS.md) for the full list of installed CLI tools with descriptions and install commands.

## License

MIT
