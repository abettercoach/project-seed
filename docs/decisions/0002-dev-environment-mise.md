# ADR-0002: Dev environment with mise + language lockfiles

- **Status:** Accepted, {{DATE}}
- **Deciders:** {{OWNER_NAME}}

## Context
We want pinned, reproducible tool versions that every AI tool and the owner share, installed per
user without admin rights (Homebrew supports one install per machine, owned by one account).

## Options
- **Homebrew:** one shared install per machine, versions drift, no per-repo pins.
- **Containers / dev containers:** Linux VMs, so no access to macOS frameworks or the GPU.
- **Nix / devbox / Flox:** very reproducible, but needs admin rights, is hard to debug, and macOS
  upgrades sometimes break it.
- **mise:** per-user, no admin rights, short readable config, pins tool versions per repo.

## Decision
- **mise** pins tools in `mise.toml`.
- Language lockfiles pin packages (e.g. `pnpm-lock.yaml`, `uv.lock`), with exact versions and only
  versions published at least 7 days ago.
- **direnv** loads per-repo env vars (the `GH_TOKEN`). The token is read from the Keychain in
  the owner's own shell, and agents never read the Keychain.
- **The shipped app never depends on mise.** It's dev tooling only.

## Consequences
- One-time shell setup per account (`docs/process/dev-setup.md`).
- If reproducibility pain shows up, revisit in a retro (devbox is the likely next step, and the
  lockfiles carry over).
