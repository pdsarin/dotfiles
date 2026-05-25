## To create pull requests

If currently on the default branch (which is main, master, or prod usually), create a new branch. Branch format is phil.sarin/yyyymmdd-brief-description.

Use the gh tool to create pull requests.

## To commit and push in a Datadog workspace

If `IN_WORKSPACE=1`, the standard `git commit` / `git push` flow is wrong:
local signing keys typically aren't reachable from a workspace, so commits
land unsigned and the branch ends up `verified: false` on GitHub. Route the
push through `commit-headless` instead so GitHub re-signs commits server-side.

Setup details: <https://datadoghq.atlassian.net/wiki/spaces/DEVX/pages/6336283013/Background+Agents+in+Workspaces#Commit-Signing>.
`install.sh` installs `commit-headless` v3.3+ to `~/.local/bin` (which wins
PATH ordering over the pre-installed v2.0.1 at `/usr/local/bin`).

- **Claude Code:** use the `create-and-push-commit` skill from the
  `workspaces` plugin (the Datadog managed-settings hook already injects a
  reminder about this on session start). Do not run raw `git commit` or
  `git push` — the skill handles co-authorship, the `Environment: Datadog
  workspace` trailer, and the `commit-headless --reset` resync.
- **Other agents (Codex, etc.):** follow the same procedure manually —
  read the skill at
  `~/.claude/plugins/marketplaces/datadog-claude-plugins/workspaces/skills/create-and-push-commit/SKILL.md`
  for the exact recipe. The short version: stage files, `git commit` (let
  signing fail), then
  `HEADLESS_TOKEN="$(ddtool auth github token)" ~/.local/bin/commit-headless push --target <owner/repo> --branch <branch> --head-sha <remote-sha> --reset`.
  Add `--create-branch` if the remote branch doesn't exist yet.
