# Dev setup (a new Mac, or a new Mac account)

Everything the dev environment needs is pinned in the repo: tool versions (`mise.toml`) and
packages (the lockfiles). So a fresh machine is these steps, in order.

**If a Mac was lost or stolen:** first revoke its GitHub token (`github-setup.md`).

1. **Xcode Command Line Tools** (git):
   ```
   xcode-select --install
   ```
2. **Install mise** (into your home folder, no admin rights needed):
   ```
   curl -fsSL https://mise.run | sh
   ```
3. **Activate mise and direnv in your shell.** Add these lines to the end of `~/.zshrc`, then
   open a new terminal window:
   ```
   # mise: per-project tool versions
   eval "$(~/.local/bin/mise activate zsh)"
   # direnv: per-folder env vars (e.g. this repo's GH_TOKEN)
   eval "$(~/.local/bin/mise x direnv@2.38.2 -- direnv hook zsh)"
   ```
   If the direnv version in `mise.toml` changes, update the second line to match. These lines
   are shared by every project, so a Mac that already has them can skip this step.
4. **GitHub token:** follow `github-setup.md` (making the token, then storing it in the
   Keychain). On a machine without the repo yet, read that file on github.com.
5. **Clone the repo** with that token (nothing is saved to git's config):
   ```
   mkdir -p ~/Documents/Dev && cd ~/Documents/Dev
   GH_TOKEN="$(security find-generic-password -s gh-token-project-seed -a "$USER" -w)" \
     ~/.local/bin/mise x gh@2.103.3 -- gh repo clone {{GH_OWNER}}/{{PROJECT}}
   ```
6. **In the repo:**
   ```
   cd ~/Documents/Dev/{{PROJECT}}
   mise trust && mise install
   direnv allow
   ```
7. **Working with Claude Code:** start `claude` *from inside the repo folder in that terminal*.
   It inherits `GH_TOKEN` from your shell, so it can use `gh` without ever reading the Keychain.
8. **Install dependencies and check:**
   ```
   just setup
   just check
   ```

Check: `mise doctor` should report no problems, and `gh auth status` (inside the repo) should
show the token.

## Not in the repo
- **The token:** only in the Keychain. Make a new one per machine.
<!-- seed: real data, models, anything else to back up or recreate -->
