# CLI Tools Reference

## 🔍 Search & Find

| Tool | Description | Install |
|------|-------------|---------|
| `rg` (ripgrep) | Blazing fast text search in files (replaces grep) | `brew install ripgrep` |
| `fd` | Fast file finder (replaces find) | `brew install fd` |
| `fzf` | Fuzzy finder for anything — files, history, branches | `brew install fzf` |

## 📁 File Viewing & Navigation

| Tool | Description | Install |
|------|-------------|---------|
| `bat` | Cat with syntax highlighting & line numbers | `brew install bat` |
| `eza` | Modern ls with colors, icons, git status | `brew install eza` |
| `glow` | Render Markdown beautifully in terminal | `brew install glow` |
| `zoxide` | Smarter cd — remembers your most-used dirs (`z verble`) | `brew install zoxide` |

## 🔧 Git & Code

| Tool | Description | Install |
|------|-------------|---------|
| `lazygit` | TUI git client — visual diffs, staging, branches | `brew install lazygit` |
| `delta` | Beautiful git diffs — side-by-side, syntax highlighting, Dracula theme | `brew install delta` |
| `gh` | GitHub CLI — PRs, issues, CI, API | `brew install gh` |
| `gh-dash` | GitHub dashboard TUI — PRs & issues across repos | `gh extension install dlvhdr/gh-dash` |
| `tokei` | Count lines of code by language | `brew install tokei` |

## 🌐 HTTP & Data

| Tool | Description | Install |
|------|-------------|---------|
| `http` (HTTPie) | Human-friendly HTTP client (replaces curl for APIs) | `brew install httpie` |
| `wget` | Download files from the web | `brew install wget` |
| `yq` | jq but for YAML/TOML/XML | `brew install yq` |

## 🤖 AI Coding Agents

| Tool | Description | Install |
|------|-------------|---------|
| `claude` | Claude Code — Anthropic's coding agent (Max sub) | `npm i -g @anthropic-ai/claude-code` |
| `codex` | OpenAI Codex CLI — sandboxed coding agent | `npm i -g @openai/codex` |
| `opencode` | Open-source coding agent | `npm i -g opencode` |

## 🌐 Browser & Scraping

| Tool | Description | Install |
|------|-------------|---------|
| `cdp.mjs` | Chrome CDP — control live Chrome tabs (list, snap, eval, click, type) | `git clone github.com/pasky/chrome-cdp-skill ~/agent-tools/chrome-cdp-skill` |
| `pick.mjs` | Interactive element picker — click element → get CSS selector | (included with chrome-cdp-skill) |

## ⚡ Shell & Prompt

| Tool | Description | Install |
|------|-------------|---------|
| `starship` | Fast, customizable shell prompt with git/node/etc info | `brew install starship` |
| `tldr` | Simplified man pages with examples | `brew install tldr` |

## 📦 Runtimes

| Tool | Description | Install |
|------|-------------|---------|
| `bun` | Fast JS runtime + bundler + package manager | `brew install bun` |
| `deno` | Secure JS/TS runtime | `brew install deno` |
| `pnpm` | Fast, disk-efficient package manager | `npm i -g pnpm` |

## Aliases (`.zshrc`)

```
cat    → bat
ls     → eza --icons
ll     → eza -la --icons --git
tree   → eza --tree --icons
diff   → delta
md     → glow
help   → tldr
search → rg
ff     → fd
lg     → lazygit (English forced)
cl     → claude code + chrome-cdp in PATH
```
