# Roadmap — `tooling`

Personal dev tooling: Claude Code commands plus shell/Node scripts.

**Current goal:** make the repo approachable — every script documented with what it
does and how to run it, plus quick wins for robustness.

## Now — make it approachable & honest

These tasks are drafted in Command Center (priority order). They mostly touch
docs and add guardrails; no behavioral rewrites.

1. **Document every script in a new `scripts/README.md`** — one section per script
   (`setup-claude-code.sh`, `agent-matrix.sh`, `agent-desktop.sh`, `trello.mjs`):
   purpose, prerequisites/env vars, copy-pasteable run command, side effects.
2. **Refresh root `README.md` as the repo front door** — index all commands
   (`/review-walk` **and** the missing `/implement`) and all scripts (add the missing
   `trello.mjs`), link out to `scripts/README.md`, add a repository-layout section.
3. **Harden the iTerm launcher scripts** — externalize the hardcoded personal project
   list out of `agent-matrix.sh` / `agent-desktop.sh`, add macOS/iTerm2/python3
   guardrails, warn on missing project dirs, standard header docblocks.
4. **Robustness pass on `setup-claude-code.sh` & `trello.mjs`** — stop swallowing
   install failures behind unconditional ✅ ticks, make the summary honest, add
   env/dependency validation and a `trello.mjs` no-args usage message.
5. **Repo hygiene quick wins** — add the `LICENSE` the README already claims (MIT)
   and a `.gitignore` (node + macOS + env-file noise) to avoid committing secrets.

## Next — consistency & confidence

- Standardize a shared header-docblock convention across all scripts (purpose, usage,
  requirements, last-updated) and a short `CONTRIBUTING`/repo-conventions note.
- Add `shellcheck` (shell) + `node --check` (mjs) as a lightweight CI check or a
  `make lint` / pre-commit hook so docs and scripts can't silently rot.
- Smoke-test the install path on a clean machine/VM and capture the result in
  `scripts/README.md`.

## Later — growth

- Grow the Claude Code command library; keep the README command table authoritative.
- Consider extracting the agent-grid/tab launchers into a single configurable script
  with a profiles file, and supporting terminals beyond iTerm2.
- Evaluate packaging the Node CLIs (e.g. `trello.mjs`) with a thin `bin` wrapper for
  global install.

---
_Tasks above are tracked as drafts in Command Center (project `tooling`). Update this
file as they land or priorities shift._
