# project-seed

A starting point for new projects: the **process**, not the code. GitHub Issues and milestones,
ADRs, a working agreement between a human owner and AI coding agents, retros, pinned tools
(mise), per-repo GitHub tokens (Keychain + direnv), and CI that runs `just check`.

This is a GitHub **template repository**. New projects are created from it on github.com, then
tailored (stack, hard rules, milestones).

## Start a new project
With Claude Code: make an empty folder `~/Documents/Dev/<project>`, start `claude` in it, and run
`/new-project`. It walks through every step, including the GitHub parts you only do once in a
while.

By hand: github.com → **New repository** → **Repository template: project-seed** → private →
create. Then follow `docs/process/github-setup.md` in the new repo, and replace the
placeholders below.

| Placeholder | Meaning |
|---|---|
| `{{PROJECT}}` | Repo and folder name, e.g. `abetter-inventory` |
| `{{PROJECT_SUMMARY}}` | One or two lines on what it is |
| `{{OWNER_NAME}}` | The human who makes the decisions |
| `{{GH_OWNER}}` | GitHub account or org that owns the repo |
| `{{DATE}}` | The day the project starts (YYYY-MM-DD) |
| `<!-- seed: ... -->` | A section to fill in or delete |

In `.envrc` and the docs, the Keychain entry name `gh-token-project-seed` changes to
`gh-token-{{PROJECT}}`.

## Changing the seed
Only through a pull request, reviewed and merged by the owner. Changes usually come from a
project's milestone retro (see `docs/process/retros.md`). Existing projects don't pick up seed
changes automatically. Each retro checks for seed changes since the project started.

The seed's own `justfile`, CI and `.envrc` work as is, so sessions inside this repo can use
`just check` and `gh` like any project.
