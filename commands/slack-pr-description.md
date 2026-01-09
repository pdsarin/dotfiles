---
description: Generate Slack-formatted PR link for current branch
---

1. Determine the current git repository and find the associated PR for the current branch
2. Get the PR details using GitHub MCP tools
3. Output the formatted Slack message in this exact format:
   ```
   :pullrequest: <PR_URL|PR_TITLE>
   ```
   Where PR_URL is the full GitHub URL and PR_TITLE is the PR title
4. This format will render in Slack as a clickable link with the emoji

If there's no PR for the current branch, inform the user.
If the current directory is not a git repository, inform the user.
