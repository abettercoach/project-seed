# Working agreement (v0)

How the owner and AI agents work together on {{PROJECT}}. Changes go through a commit/PR like
code, and the reason goes in `retros.md`.

## Goals
- The owner stays familiar with the code and makes the granular decisions that matter.
- The process stays small and works with any tool. The repo is the memory.

## Who decides what
**Owner decides** (the agent proposes, then waits):
- Interfaces between components
- Data schemas and on-disk layout
- New dependencies, languages, or tools
- UI flows and anything user-facing
- Changes to this agreement or to process (here or in project-seed)
<!-- seed: add project-specific items -->

**The agent decides** (and explains in the PR):
- Internals within an agreed interface, refactors, tests, naming within a module

## Rhythm
- **Start of a session:** read `AGENTS.md` and the issue; restate the goal in one or two lines.
- **Non-trivial work:** a short plan in the issue or chat first; the owner approves.
- **Accepting an ADR:** the same PR updates `docs/architecture.md`, so the current design never
  falls behind the decisions. Proposals are snapshots: frozen once decided, not maintained.
- **Changes:** small commits, each reviewable as a diff.
- **If the owner edits code:** the owner says "I changed X", and the agent reads the
  diff before continuing.
- **End of a session:** a handoff comment on the issue.
- **End of a milestone:** a demo, then a 15-minute retro (see `retros.md`). If the retro's change
  would help every project, the agent opens a PR against project-seed.

## Preferences
- Always provide a UI path; never require the owner to remember terminal commands to *use*
  the app.
- Keep code readable: small modules, `docs/architecture.md` as the map.
- _(add more as we learn)_
