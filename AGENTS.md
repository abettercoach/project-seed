# AGENTS.md

This is the onboarding doc for **any** AI coding agent (Claude, Codex, Cursor, local models)
and for humans. Keep it short. If a fact is load-bearing, it belongs here or in a doc linked
from here, not in one tool's private memory.

## What {{PROJECT}} is
{{PROJECT_SUMMARY}}

Current design: `docs/architecture.md` · Decisions: `docs/decisions/` ·
How we work: `docs/process/working-agreement.md`

## Hard rules
<!-- seed: project-specific rules go first (private data, network, what never leaves the machine).
     Delete this comment when done. -->
1. **Never read the Keychain or print tokens.** `GH_TOKEN` comes from the owner's shell.
   No secrets in the repo, issues, commits, or PRs.
2. **Ask before deciding** anything in the working agreement's "Owner decides" list
   (interfaces, schemas, new dependencies, UX flows, process changes).
3. Don't push, open or close issues, or change GitHub settings unless the task says to.
4. **project-seed changes only as a PR**, and never merge one. The owner reviews and merges.

## Workflow
- Work is tracked in **GitHub Issues** (milestones = roadmap phases). One issue → one branch
  (`feat/<issue#>-short-name`) → small commits → PR into `main`.
- Labels (`.github/labels.txt`): one `type:` and one `area:` per issue; `ready` when it's clear
  enough to start; `needs-owner` while waiting on an owner decision or check.
- Before calling something done, run `just check` and show how you verified the acceptance
  criteria. List any manual checks that only the owner can do.
- End each work session with a handoff comment on the issue: state, open questions, next step.
- End each milestone with a demo and a retro (`docs/process/retros.md`).

## Environment
Tool versions are pinned in `mise.toml` (ADR-0002). First-time setup: `docs/process/dev-setup.md`.
GitHub access and tokens: `docs/process/github-setup.md`.

## Commands
Every command is a `just` recipe (`justfile`). Tools come from mise (`mise.toml`).

| Command | What |
|---|---|
| `just setup` | Install dependencies from the lockfiles |
| `just dev` | Run the app in dev mode |
| `just check` | Lint + typecheck + all tests. **Run before calling anything done.** |
| `just test` / `just lint` / `just typecheck` | The parts of `check` |
| `just fmt` | Fix formatting |

New dependencies: pin exact versions, and only versions published at least 7 days ago.

## Repo map
| Path | What |
|---|---|
| <!-- seed: code folders --> | |
| `docs/architecture.md` | Current design (living; updated with each accepted ADR) |
| `docs/decisions/` | ADRs (numbered, short; accepted ADRs are not edited, only superseded) |
| `docs/process/` | Working agreement, retros, setup guides |
| `.github/` | Issue and PR templates, CI |
