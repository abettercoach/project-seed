# GitHub setup: repo, token, and access

Goal: this repo uses a token that can reach **only this repo and project-seed**, and other
projects use their own tokens. `gh` prefers the `GH_TOKEN` environment variable over its saved
login, and direnv sets that variable whenever you're inside this folder.

The token never passes through an agent. You make it in the browser and store it in a Terminal
window of your own, not in the Claude session.

Keychain name for this repo: **`gh-token-{{PROJECT}}`** (`gh-token-project-seed` in the seed
itself). `.envrc` builds it from the folder name, so the folder must be named exactly like the repo.

## Is it working?
Run these inside the repo folder:
```
gh auth status                              # should say it's using GH_TOKEN
gh repo view                                # this repo
gh repo view {{GH_OWNER}}/project-seed      # the seed
```
If `gh auth status` says the token is invalid or expired, see **Rotating**. If `GH_TOKEN` is
empty, run `direnv allow` (and then `direnv reload` if you just changed the Keychain).

## Making the token (new project, new Mac, or rotating)
1. Go to github.com → your avatar (top right) → **Settings** → **Developer settings** (bottom
   of the left sidebar) → **Personal access tokens** → **Fine-grained tokens** →
   **Generate new token**.
2. Fill in:
   - **Token name:** `{{PROJECT}}-<this Mac's name>` (e.g. `{{PROJECT}}-macbook`), so you can
     tell tokens apart later
   - **Expiration:** 90 days. Put a calendar reminder a few days before it expires.
   - **Resource owner:** `{{GH_OWNER}}`
   - **Repository access:** **Only select repositories** → this repo **and** `project-seed`
   - **Repository permissions:**
     - **Contents:** Read and write (code, branches)
     - **Issues:** Read and write (issues, labels, milestones)
     - **Pull requests:** Read and write
     - **Workflows:** Read and write (needed to push changes to `.github/workflows/`)
     - **Metadata:** Read (added automatically)
     - Everything else: No access
3. Click **Generate token** and copy it. GitHub shows it only once.
4. If `{{GH_OWNER}}` is an organization, the token may say **pending approval**: approve it under
   the organization → **Settings** → **Personal access tokens** → **Pending requests**.

## Storing it in the Keychain
In a Terminal window of your own (not the Claude session):
```
security add-generic-password -U -s gh-token-{{PROJECT}} -a "$USER" -w
```
Paste the token at the prompt. ⚠️ Leave **nothing** after `-w` so it prompts you. A token typed
on the command line is saved in plain text in `~/.zsh_history`. `-U` replaces an existing entry,
so the same command works for rotating.

Then, in the repo folder: `direnv reload`. direnv doesn't notice Keychain changes on its own.
If a Claude session is open, quit it and start `claude` again from that terminal so it picks up
the new token.

## Pulling and pushing
Git borrows the token from `gh` one command at a time, so nothing is saved to git's config:
```
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' pull    # or push
```
Plain `git pull` asks for a username and password. (`gh auth setup-git` would make it
automatic, but it changes your global git config.)

## Rotating
Make a new token (above, same settings), store it with the same `security ... -U` command, then
`direnv reload`. Delete the old token on GitHub.

## A lost or stolen Mac
First revoke its token: github.com → Settings → Developer settings → Fine-grained tokens → the
token → **Delete**. Then make a new one on the new Mac (`dev-setup.md`).
