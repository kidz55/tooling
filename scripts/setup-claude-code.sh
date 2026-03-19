#!/bin/bash
# setup-claude-code.sh — Portable Claude Code setup for new laptops
# Run: curl -sL <url> | bash  OR  bash setup-claude-code.sh
# Last updated: 2026-03-17

set -euo pipefail

echo "🚀 Setting up Claude Code environment..."

# ─── 1. Node.js ───────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "📦 Installing Node.js via nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 22
else
  echo "✅ Node.js $(node --version) already installed"
fi

# ─── 2. Package managers ──────────────────────────────────────
npm install -g pnpm 2>/dev/null && echo "✅ pnpm installed" || echo "⚠️ pnpm already exists"

# ─── 3. Coding agents ─────────────────────────────────────────
echo "📦 Installing coding agents..."
npm install -g @anthropic-ai/claude-code 2>/dev/null && echo "✅ Claude Code installed"
npm install -g @openai/codex 2>/dev/null && echo "✅ Codex installed"
npm install -g openclaw 2>/dev/null && echo "✅ OpenClaw installed"

# ─── 4. CLI tools (macOS only) ────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  echo "📦 Installing CLI tools via Homebrew..."
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install ripgrep fd bat eza starship zoxide fzf lazygit delta glow tldr tokei wget httpie yq 2>/dev/null
  brew install --cask google-cloud-sdk 2>/dev/null
  echo "✅ CLI tools installed"
fi

# ─── 5. Chrome CDP skill ──────────────────────────────────────
echo "📦 Installing Chrome CDP skill..."
mkdir -p ~/agent-tools
if [ ! -d ~/agent-tools/chrome-cdp-skill ]; then
  git clone https://github.com/pasky/chrome-cdp-skill.git ~/agent-tools/chrome-cdp-skill
  echo "✅ chrome-cdp-skill cloned"
else
  cd ~/agent-tools/chrome-cdp-skill && git pull --ff-only 2>/dev/null
  echo "✅ chrome-cdp-skill updated"
fi

# ─── 6. Everything Claude Code (ECC) ──────────────────────────
echo "📦 Installing ECC (Everything Claude Code)..."
if [ ! -d ~/agent-tools/everything-claude-code ]; then
  git clone https://github.com/affaan-m/everything-claude-code.git ~/agent-tools/everything-claude-code
  cd ~/agent-tools/everything-claude-code && npm install --omit=dev
  echo "✅ ECC cloned + deps installed"
else
  cd ~/agent-tools/everything-claude-code && git pull --ff-only 2>/dev/null && npm install --omit=dev
  echo "✅ ECC updated"
fi

# ─── 7. Install ECC components ────────────────────────────────
echo "📦 Installing ECC agents, rules, commands, skills, hooks..."
ECC=~/agent-tools/everything-claude-code
mkdir -p ~/.claude/agents ~/.claude/rules ~/.claude/commands ~/.claude/skills

# Agents
for a in planner architect tdd-guide code-reviewer security-reviewer build-error-resolver refactor-cleaner doc-updater e2e-runner; do
  cp "$ECC/agents/$a.md" ~/.claude/agents/ 2>/dev/null
done
echo "✅ $(ls ~/.claude/agents/ | wc -l | tr -d ' ') agents installed"

# Rules (common + typescript)
cp -r "$ECC/rules/common/"* ~/.claude/rules/ 2>/dev/null
cp -r "$ECC/rules/typescript/"* ~/.claude/rules/ 2>/dev/null
echo "✅ $(ls ~/.claude/rules/ | wc -l | tr -d ' ') rules installed"

# Commands
for c in tdd plan code-review build-fix refactor-clean learn learn-eval checkpoint verify setup-pm update-docs test-coverage sessions e2e eval evolve harness-audit instinct-status loop-start loop-status model-route quality-gate skill-create; do
  cp "$ECC/commands/$c.md" ~/.claude/commands/ 2>/dev/null
done
echo "✅ $(ls ~/.claude/commands/ | wc -l | tr -d ' ') commands installed"

# Skills
for s in search-first tdd-workflow frontend-patterns coding-standards continuous-learning-v2 security-review backend-patterns iterative-retrieval strategic-compact verification-loop eval-harness autonomous-loops e2e-testing api-design deployment-patterns configure-ecc; do
  [ -d "$ECC/skills/$s" ] && cp -r "$ECC/skills/$s" ~/.claude/skills/
done
echo "✅ $(ls ~/.claude/skills/ | wc -l | tr -d ' ') skills installed"

# Hooks + scripts + contexts
cp "$ECC/hooks/hooks.json" ~/.claude/hooks.json
cp -r "$ECC/scripts" ~/.claude/scripts
cp -r "$ECC/contexts" ~/.claude/contexts
echo "✅ hooks, scripts, contexts installed"

# ─── 8. CLAUDE.md ─────────────────────────────────────────────
if [ ! -f ~/.claude/CLAUDE.md ]; then
  cat > ~/.claude/CLAUDE.md << 'CLAUDEMD'
# Global Claude Code Instructions

## ECC (Everything Claude Code) — Active

You have access to the ECC agent harness system. Use it.

### Slash Commands (type / to use)
- `/plan` — Create implementation plan before coding (ALWAYS use for features)
- `/tdd` — Test-driven development workflow (RED → GREEN → REFACTOR)
- `/code-review` — Security + quality review of uncommitted changes
- `/build-fix` — Fix build/type errors with minimal changes
- `/refactor-clean` — Find and remove dead code safely
- `/verify` — Run full verification (build → types → lint → tests)
- `/test-coverage` — Analyze test coverage gaps
- `/learn` — Extract reusable patterns from current session
- `/quality-gate` — Run quality checks before merging
- `/checkpoint` — Save verification state

### Subagents (auto-delegated)
- **planner** — Feature planning and risk assessment
- **architect** — System design decisions
- **code-reviewer** — Quality + security review
- **tdd-guide** — Test-first development
- **security-reviewer** — Vulnerability detection
- **build-error-resolver** — Fix build errors fast
- **refactor-cleaner** — Dead code removal

### Development Workflow
1. `/plan` first — never start coding without a plan
2. `/tdd` — write tests before implementation
3. `/verify` — after changes, verify everything passes
4. `/code-review` — review before committing
5. `/learn` — extract patterns worth keeping

### Rules (always active)
- Immutability: create new objects, never mutate
- Files: 200-400 lines typical, 800 max
- Functions: < 50 lines, no deep nesting (> 4 levels)
- Git: conventional commits (feat/fix/refactor/docs/test/chore)
- Tests: 80%+ coverage, TDD mandatory for features
- Security: validate all input, no hardcoded secrets

## Browser Tools (chrome-cdp)

When asked to interact with Chrome, read `~/agent-tools/chrome-cdp-skill/skills/chrome-cdp/SKILL.md`.

Key commands (in PATH via `cl` alias):
- `cdp.mjs list` — list open tabs
- `cdp.mjs snap <target>` — accessibility tree
- `cdp.mjs shot <target>` — screenshot
- `cdp.mjs eval <target> "expr"` — run JS in page
- `cdp.mjs click <target> "selector"` — click element
- `pick.mjs <target> ["message"]` — interactive element picker

Requires: `chrome://inspect/#remote-debugging` toggle ON.

## Project Context
- **Package manager:** pnpm
- **Stack:** TypeScript, Next.js 14+, React, Tailwind, Radix UI, Firebase
CLAUDEMD
  echo "✅ CLAUDE.md created"
else
  echo "✅ CLAUDE.md already exists (skipped)"
fi

# ─── 9. settings.json ─────────────────────────────────────────
if [ ! -f ~/.claude/settings.json ]; then
  cat > ~/.claude/settings.json << 'SETTINGS'
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "voiceEnabled": true,
  "skipDangerousModePermissionPrompt": true,
  "extraKnownMarketplaces": {
    "everything-claude-code": {
      "source": {
        "source": "github",
        "repo": "affaan-m/everything-claude-code"
      }
    }
  },
  "enabledPlugins": {
    "everything-claude-code@everything-claude-code": true
  }
}
SETTINGS
  echo "✅ settings.json created"
else
  echo "✅ settings.json already exists (skipped)"
fi

# ─── 10. Shell alias ──────────────────────────────────────────
ALIAS_LINE='alias cl="PATH=\$PATH:\$HOME/agent-tools/chrome-cdp-skill/skills/chrome-cdp/scripts claude --dangerously-skip-permissions"'
if ! grep -q "alias cl=" ~/.zshrc 2>/dev/null; then
  echo "" >> ~/.zshrc
  echo "# Claude Code with chrome-cdp in PATH" >> ~/.zshrc
  echo "$ALIAS_LINE" >> ~/.zshrc
  echo "✅ cl alias added to .zshrc"
else
  echo "✅ cl alias already in .zshrc"
fi

# ─── Done ──────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════"
echo "  ✅ Claude Code setup complete!"
echo ""
echo "  What's installed:"
echo "    • Claude Code + Codex + OpenClaw"
echo "    • Chrome CDP skill (live browser control)"
echo "    • ECC: 9 agents, 9 rules, 23 commands, 16 skills, 21 hooks"
echo "    • CLI tools (rg, fd, bat, eza, lazygit, delta, etc.)"
echo ""
echo "  Next steps:"
echo "    1. source ~/.zshrc"
echo "    2. Chrome → chrome://inspect/#remote-debugging → toggle ON"
echo "    3. cl  (to start Claude Code)"
echo "    4. /plan \"your feature\" (to test ECC)"
echo "════════════════════════════════════════════════"
