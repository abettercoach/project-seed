---
name: new-project
description: Start a new project from the project-seed template (GitHub repo, per-repo token, Keychain + direnv, mise, process docs, milestones), walking the owner through every GitHub step. Use when the user runs /new-project, or asks to set up / start / create a new project or repo "like bemba" or "from the seed". Run from inside the new project's (empty) folder.
---

# New project from project-seed

The owner sets up a new repo only every few months and won't remember the steps.
**Walk them through every step they do themselves, one at a time**, with the exact clicks and
commands. Wait for them to confirm each of those steps before the next. Never skip a step
because it "seems obvious."

**Your own steps are different: do them, then report.** Running the skill is the owner's go-ahead
for the routine setup work (the setup branch, push and PR, labels, milestones, the agreed M0
issues). Don't ask for a yes on each one. Ask only for real decisions: product, scope, stack,
private data, licensing, or anything the answers don't settle.

Defaults: GitHub owner `abettercoach`, projects in `~/Documents/Dev/`,
seed at `abettercoach/project-seed` (public template repo). Confirm these at the start, in one line.
Don't ask for or write the owner's name anywhere: the docs say "the owner".

This skill lives in project-seed at `seed-tools/new-project/SKILL.md` and is symlinked into
`~/.claude/skills/`. Improve it only through a seed PR (see **Seed PRs**).

## Hard rules for this skill
- **Stay inside the project folder.** Don't read other projects or `~/Documents/Dev` itself
  (including the local `project-seed` clone). Read seed files from GitHub:
  `https://raw.githubusercontent.com/abettercoach/project-seed/main/<path>`.
- **The token never passes through you.** Never run `security find-generic-password`, never
  print `GH_TOKEN`, and never ask the user to paste a token into the chat. To check it, use
  `[ -n "$GH_TOKEN" ] && echo set || echo empty` and `gh auth status`.
- Commands with `security` or anything that reads the Keychain: the user runs them **in a
  Terminal window of their own**, not with `!` in this session.
- GitHub writes outside the setup work above (settings, deleting anything, other repos) need
  a yes first.
- **Never merge a PR to project-seed.**
- Always fill in the project name and owner literally in instructions; never show placeholders.

## Things that are expected, not problems
- **`.claude/` appears in the "empty" folder** as soon as Claude Code starts (e.g.
  `.claude/.cc-writes/`). That's why Part 1 fetches into the folder with `git init` + `pull`
  instead of `gh repo clone .`, which refuses a non-empty folder. Never ask the user to delete it.
- **`direnv version` fails outside a repo** ("No version is set for shim"). direnv comes from
  each repo's `mise.toml`. The real check is `type _direnv_hook`.
- **You can't see the new repo before the token exists**: it's private. The pull in 1.5 is the
  check.
- **Your shell doesn't have the direnv hook.** Only the user's Terminal does, so the user runs
  that check.

## Step 0: where are we?
The setup spans one Claude restart (`claude --continue`), so figure out the stage every time:
```
pwd; ls -A
git rev-parse --is-inside-work-tree 2>/dev/null && git remote -v && git log --oneline -3
grep -rl '{{PROJECT}}' . --exclude-dir=.git 2>/dev/null | head -3
[ -n "$GH_TOKEN" ] && echo "GH_TOKEN set" || echo "GH_TOKEN empty"
```
- No git (the folder is empty apart from `.claude/` and maybe `setup-handoff/`) → **Part 1**.
- Git, placeholders there, `GH_TOKEN` empty → the user hasn't restarted from their Terminal
  yet: repeat **1.6**.
- Git, placeholders there, `GH_TOKEN` set → **Part 2**.
- No placeholders left → setup is done. Run the **Final check** and report anything missing.

**A prepared handoff:** if `setup-handoff/SETUP.md` exists, read it first, at any stage. Another
session wrote it with the owner: it pre-answers the 2.1 interview, lists the M0 issues, and says
where its other files go. Don't re-ask what it answers; ask only what it marks **open**. The
`git pull` in 1.5 works with it there (the seed has no `setup-handoff/` path).

The project name is the folder name (`basename "$PWD"`). It must be lowercase with hyphens
(e.g. `abetter-inventory`), and it must match the GitHub repo name exactly, because `.envrc`
builds the Keychain name from it. If it isn't, stop and ask before doing anything else.

## Part 1: repo, token, clone (the user, in the browser and their own Terminal)

**1.1 The seed is published?** Run `git ls-remote https://github.com/abettercoach/project-seed.git HEAD`.
If it fails, walk through **Appendix A** first. Also read the seed's pinned versions
(`curl -fsSL https://raw.githubusercontent.com/abettercoach/project-seed/main/mise.toml`) and
use its `gh` version in 1.5.

**1.2 Mac tools.** Ask the user to open a new Terminal window (⌘N) and run:
```
~/.local/bin/mise --version
type _direnv_hook
```
Expected: a mise version, and `_direnv_hook is a shell function`. If mise is missing or the
hook is "not found", walk through steps 1–3 of the seed's `docs/process/dev-setup.md`
(Xcode Command Line Tools, install mise, the two `~/.zshrc` lines, new window), then re-check.
Keep that Terminal window open: every user command below goes there.

**1.3 Create the repo from the template.** Tell them:
1. Open https://github.com/new
2. **Repository template:** choose `abettercoach/project-seed`. Leave **Include all branches**
   unchecked.
3. **Owner:** `abettercoach` · **Repository name:** `<project>` (exactly the folder name)
4. **Private**
5. **Create repository**

GitHub copies the seed's files into the new repo as one commit. (It doesn't copy labels,
milestones, or settings; Part 2 does those.)

**1.4 Make the token.** The token can only include repos that already exist, so this comes after
1.3. Give the steps from the seed's `docs/process/github-setup.md`, "Making the token", filled
in:
1. github.com → avatar → **Settings** → **Developer settings** → **Personal access tokens** →
   **Fine-grained tokens** → **Generate new token**
2. **Name:** `<project>-<Mac name>` · **Expiration:** 90 days (say the exact date, and to set a
   calendar reminder) · **Resource owner:** `abettercoach`
3. **Only select repositories:** `<project>` **and** `project-seed`
4. **Permissions:** Contents, Issues, Pull requests, Workflows: **Read and write**. Metadata: Read.
   Nothing else.
5. **Generate token**, copy it (GitHub shows it once). If it says *pending approval*, approve it
   in the org's Settings → Personal access tokens → Pending requests.

Explain once why project-seed is included: retros (and this skill) send process improvements
back as PRs.

**1.5 Store the token, fetch the repo, set up tools.** Two commands in the user's Terminal.
First, on its own (it prompts for the token, so nothing may be pasted after it):
```
security add-generic-password -U -s gh-token-<project> -a "$USER" -w
```
Paste the token at both prompts. Stress that nothing goes after `-w`, because a token typed on
the command line ends up in plain text in `~/.zsh_history`.

Then this block, as one paste:
```
cd ~/Documents/Dev/<project> && \
git init -q -b main && \
git remote add origin https://github.com/abettercoach/<project>.git && \
GH_TOKEN="$(security find-generic-password -s gh-token-<project> -a "$USER" -w)" \
  ~/.local/bin/mise x gh@<gh version> -- \
  git -c credential.helper= -c 'credential.helper=!gh auth git-credential' pull -q origin main && \
git branch -q -u origin/main && \
mise trust -q && mise install && direnv allow && \
mise x -- direnv exec . gh repo view --json nameWithOwner -q .nameWithOwner
```
It should end by printing `abettercoach/<project>`. If macOS asks about Keychain access, click
**Allow** (not *Always Allow*). If the pull fails with 403/404: the token is pending approval,
lacks the repo, or the repo name doesn't match the folder.

Then confirm it yourself: `git log --oneline`, `ls -A`.

**1.6 Restart Claude inside that Terminal.** This session started without `GH_TOKEN`, and only a
new process picks it up. Tell them, as the last thing in this part:
1. Quit this session (`/exit`).
2. In the same Terminal window, in the project folder: `claude --continue`
3. Say "continue". The conversation resumes here with the token.

## Part 2: tailor the repo (you, with the owner's answers)
Check first: `gh auth status`, `gh repo view`, `gh repo view abettercoach/project-seed`. If any
of them fail, go back to the matching Part 1 step.

If the user noted problems with this skill or the seed during Part 1, offer the seed PR now
(see **Seed PRs**) before continuing.

**2.1 Interview** (ask in one go, then follow up only where needed). With a `setup-handoff/SETUP.md`,
skip every question it answers:
1. In one or two lines, what is it? Who uses it?
2. Hard rules: private or client data? Must anything stay local, with no network calls? What should
   an agent never read?
3. Stack: decided (which languages and frameworks), or not yet? If not yet, the stack becomes an
   M0 ADR issue.
4. First milestones: names and a line each (bemba's pattern: M0 Foundation, then one per product
   phase).
5. Anything else for the "Owner decides" list?
6. Areas for the `area:` labels: the main parts of the project (bemba's were engine, ui, audio,
   macos, models, process). `area:process` is already in the seed. If the stack is undecided,
   add areas later.

**2.2 Fill in the files** on a branch `chore/setup-from-seed`:
- `git rm -r seed-tools` (the skill belongs to the seed, not to each project).
- `.github/labels.txt`: add one `area:<name>|0e8a16|<description>` line per area from 2.1.
- Replace `{{PROJECT}}`, `{{PROJECT_SUMMARY}}`, `{{GH_OWNER}}`
  (abettercoach), `{{DATE}}` (today) everywhere. Check none are left:
  `grep -rn '{{' . --exclude-dir=.git`
- `AGENTS.md`: the project's hard rules go **first** in the hard-rules list. Fill in the repo map,
  and the commands once the stack is known. Remove every `<!-- seed: ... -->` comment once its
  section is filled (or delete the section).
- `.claude/settings.json`: add `Read(...)` denies for any private data paths from 2.1. Use the
  Edit tool (the shell sandbox blocks writes to this file).
- `docs/process/working-agreement.md`: extra "Owner decides" items.
- `README.md`: rewrite for this project (name, one-line summary, status: M0).
- If the stack is decided: add its tools to `mise.toml` (exact versions), fill the `justfile`
  recipes, add lockfiles and the supply-chain guard (for pnpm: `minimumReleaseAge: 10080` and
  `saveExact: true` in `pnpm-workspace.yaml`), and add stack ignores to `.gitignore`. A stack
  choice is an "Owner decides" item: propose it, then wait. If it's undecided, leave the
  skeleton recipes as they are.
- With a handoff: move its files where `SETUP.md` says, then delete `setup-handoff/`
  (`SETUP.md` itself is never committed; its answers now live in the repo's files).
- Keep the commit small and readable. Summarize `git diff --stat` and the key changes in the PR.

**2.3 Push and open the PR:**
```
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push -u origin chore/setup-from-seed
gh pr create --fill
```
The owner reviews and merges it. CI runs `just check`.

**2.4 GitHub setup** (do it, then list what was created):
- Milestones: `gh api repos/abettercoach/<project>/milestones -f title="M0: Foundation" -f description="..."`
- Open the M0 issues from the interview or `SETUP.md` (e.g. a stack ADR, first spike). Use the
  Task template's sections: Why / Acceptance criteria / Out of scope / How to verify.
- Labels: `just labels`. It creates or updates everything in `.github/labels.txt` and leaves
  GitHub's default labels alone. Run it after the setup PR is merged, or from the branch.
  Label the M0 issues with them.

**2.5 Optional repo settings** for the user to click (tell them; don't change settings
yourself): Settings → General → Pull Requests → **Automatically delete head branches**.

## Final check
- `grep -rn '{{' . --exclude-dir=.git` finds nothing, and `seed-tools/` is gone
- `gh auth status` and `gh repo view abettercoach/project-seed` work
- `just check` passes
- Milestones exist: `gh api repos/abettercoach/<project>/milestones --jq '.[].title'`
- Labels exist: `gh label list | grep -c 'type:'` shows 5
- Tell the owner the token's expiry date (90 days from the day it was made) for the calendar,
  and that `docs/process/github-setup.md` in the repo covers rotating, a new Mac, and
  pushing/pulling.

## Preparing a handoff for a new project (from another session)
When the owner decides in another project's session to start a new repo, make setup quick:
create `~/Documents/Dev/<project>/setup-handoff/` with a `SETUP.md` holding the 2.1 answers
(what it is, hard rules, stack, milestones, owner-decides items, areas), the M0 issues to open,
and where any other files in the folder go. Mark anything undecided as **open**. Then the owner
runs `claude` in `~/Documents/Dev/<project>` and `/new-project`.

## Seed PRs
When something in this skill or the seed's process files was wrong or clumsy, fix it in the
seed, not just for this run:
1. Clone the seed from GitHub into the scratchpad (never the local `~/Documents/Dev/project-seed`):
   `git clone https://github.com/abettercoach/project-seed.git` → branch `chore/<short-name>`.
2. Make the change, show `git diff`, and get a yes.
3. Push with the credential-helper pattern above, then
   `gh pr create -R abettercoach/project-seed --fill`. The token from 1.4 covers project-seed.
4. **Never merge it.** Tell the owner: once merged, `git pull` in `~/Documents/Dev/project-seed`
   updates this skill (it's a symlink).

## Appendix A: publishing project-seed (once, or after losing it)
The user does this in the browser and their own Terminal. The seed lives in
`~/Documents/Dev/project-seed`. Don't read it yourself; just give the steps.
1. https://github.com/new → **Owner** `abettercoach` · **Name** `project-seed` · **Public** · no
   README, .gitignore, or license → **Create repository**
2. Token: same as 1.4, but name it `project-seed-<Mac name>`, and include only `project-seed`.
   Same permissions.
3. Store it in their own Terminal: `security add-generic-password -U -s gh-token-project-seed -a "$USER" -w`
4. Push:
   ```
   cd ~/Documents/Dev/project-seed
   mise trust && mise install && direnv allow
   git remote add origin https://github.com/abettercoach/project-seed.git
   git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push -u origin main
   ```
5. Mark it as a template: repo **Settings** → **General** → check **Template repository**.
6. Protect `main`: **Settings** → **Rules** → **Rulesets** → **New ruleset** → **New branch
   ruleset**.
   - **Name:** `main via PR` · **Enforcement:** Active · **Bypass list:** leave empty
   - **Target branches:** Add target → **Include default branch**
   - Check **Restrict deletions**, **Block force pushes**, **Require a pull request before
     merging** (required approvals: 0, since you can't approve your own PR)
   - **Create**

   With this ruleset, nothing reaches the seed's `main` without a PR. It doesn't stop a merge
   made with the token, so the "never merge" rule for agents is a convention.
7. Install the skill: `ln -s ~/Documents/Dev/project-seed/seed-tools/new-project ~/.claude/skills/new-project`
   (move any old copy out of the way first).
