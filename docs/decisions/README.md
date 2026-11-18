# Decisions (ADRs)

Numbered, short, and immutable once accepted. To change a decision, write a new ADR that
supersedes the old one.

- **When to write one:** only for decisions on the working agreement's "Owner decides"
  list that are hard to undo (stack, schemas, protocols, on-disk layout). Smaller choices go in
  the PR description.
- **Numbers are assigned at merge.** Take the next free number when the ADR lands on `main`.
  Until then, issues and docs refer to it by name ("the storage ADR"), never by a planned number.

Template:
```
# ADR-NNNN: Title
- Status: Proposed | Accepted | Superseded by ADR-XXXX
- Deciders:
## Context
## Options (if contested)
## Decision
## Consequences
```
