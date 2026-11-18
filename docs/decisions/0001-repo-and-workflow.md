# ADR-0001: Repo from project-seed, GitHub Issues, per-repo token

- **Status:** Accepted, {{DATE}}
- **Deciders:** Owner

## Context
We want the same small, tool-agnostic process in every project, without rebuilding it each time,
and without one project's agent being able to reach another project.

## Decision
- The repo starts from the `project-seed` template: process files only, no code.
- Track work in GitHub Issues on a private repo, with milestones per roadmap phase.
- Give `gh` access through a fine-grained token scoped to **this repo and project-seed** only,
  loaded from the Keychain via direnv (see `docs/process/github-setup.md`). project-seed is
  included so process improvements from retros can go back as PRs.
- Process docs are tool-agnostic (`AGENTS.md`). Tool-specific files only add convenience.

## Consequences
- Agents can work issues with `gh`, but can't reach other projects.
- The token can also write to project-seed. Changes there go through PRs that only
  the owner merges (AGENTS.md hard rules; `main` is protected in project-seed).
- The token expires and needs rotating.
