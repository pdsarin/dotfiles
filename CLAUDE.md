## To create pull requests

If currently on the default branch (which is main, master, or prod usually), create a new branch. Branch format is phil.sarin/yyyymmdd-brief-description.

Use the github mcp to create pull requests.

## Merging pull requests

Add the pull request to the merge queue by using the github mcp to add a "/merge" comment to the pull request. Do this only when I ask you to. Don't directly merge as we'd prefer to use the merge queue.

## PR Stack Merge Procedure

When merging a stack of PRs using git machete, follow this 7-step procedure for each
 PR after the previous one has been merged:

### Steps to queue next PR in stack:

1. **Pull latest main**
   ```bash
   git pull origin main
   ```
2. Switch to next branch
   ```bash
   git checkout <next-branch-name>
   ```
3. Rebase against main
   ```bash
   git rebase main
   ```
4. Force push rebased branch
   ```bash
   git push --force-with-lease
   ```
5. Add /merge comment using MCP
  - Use mcp__github__add_issue_comment with /merge as the comment body
6. Switch to previously merged branch and slide it out
   ```bash
   git checkout <previously-merged-branch>
   git machete slide-out --no-interactive-rebase
   ```
7. Manually delete the merged branch
   ```bash
   git branch -D <previously-merged-branch>
   ```

Notes:

- Use git machete status to see the current PR stack and PR numbers
- Monitor PR merge status using mcp__github__get_pull_request before proceeding to
next branch
- Always use --no-interactive-rebase with slide-out to avoid conflicts
- Use --force-with-lease for safer force pushing
