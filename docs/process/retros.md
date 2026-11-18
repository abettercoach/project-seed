# Retros

One entry per milestone (newest first). Three questions, one change.

```
## M<n>: <date>
- Helped:
- Got in the way:
- One change: (link the commit that updates working-agreement.md)
- Seed: (link the project-seed PR, or "project-specific")
```

## At each retro, the agent also
1. Asks whether the one change would help every project. If yes, it opens a PR against
   `{{GH_OWNER}}/project-seed` (branch `retro/{{PROJECT}}-m<n>`), changing the seed's generic
   files with placeholders instead of this project's names. It links the PR above and never
   merges it.
2. Lists project-seed PRs merged since this project started (or since the last retro), so
   {{OWNER_NAME}} can decide whether to bring any of them here:
   `gh pr list --repo {{GH_OWNER}}/project-seed --state merged --search "merged:>=<date>"`
