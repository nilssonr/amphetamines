---
name: github-pr-review
description: Acquire a GitHub PR locally from a PR URL, track temp workspace lifecycle, and invoke the review skill. Use when a PR URL is provided and code must be fetched for review.
---

# GitHub PR Review

## Inputs
- GitHub PR URL (required).

## Workflow
Start every response with: "Using github-pr-review".
1. Resolve PR metadata.
   - Prefer GitHub CLI: `gh pr view <url> --json number,title,baseRefName,headRefName,headRepository,files,commits,author,createdAt,url`.
   - Always use `headRepository` (e.g., `headRepository.fullName`) for repo identity. Parse the PR URL to extract owner/repo/number as needed.
   - If `gh` is unavailable, parse the PR URL to extract owner/repo/number. Ask the user to provide one of: (a) `gh` access, (b) a patch/diff file, or (c) the base branch name plus the head branch or commit SHA.
2. Fetch the correct diff against the target branch.
   - Use `gh pr diff <url>` to obtain the unified diff against the PR base.
   - For deeper inspection, checkout the PR head: `gh pr checkout <url>` and diff against the base ref: `git fetch origin <baseRefName>` then `git diff origin/<baseRefName>...HEAD`.
   - If the PR is from a fork, ensure remotes for both base and head repos; rely on `gh pr checkout` when possible.
   - Always work in a temporary directory under `/tmp` (e.g., `/tmp/gh-pr-review-<repo>-<number>`), and avoid using the user's existing working trees.
   - Prefer using `scripts/review_pr.sh` to create the temp workspace, clone the base repo, checkout the PR head, and generate a diff. Record every temp path created (workspace, diff files, diffstat, etc.).
3. Invoke the review skill for all analysis and findings.
   - Provide the review skill with: PR title/description, base branch, head branch, diff path, changed files list, tests/CI results if available, ownership context if available, and release path if available.
   - Do not perform review logic here; only facilitate access to code and context.

Example handoff payload:
```
PR: <url>
Title: <title>
Description: <what/why/how tested/risk/rollback>
Base branch: <baseRefName>
Head branch: <headRefName>
Diff path: /tmp/gh-pr-review-<repo>-<number>/diff.patch
Changed files: <list or path>
Tests/CI: <summary or link>
Ownership: <CODEOWNERS/required reviewers>
Release path: <feature flag/staged rollout/none>
Cleanup: rm -rf <path1> \<newline><path2> ...
```
4. Cleanup instruction.
   - Never execute `rm -rf`.
   - Record every temp path created and pass a single copy-pastable cleanup command to the review skill to include under **Required Actions**.

## Output format
- Begin with a single line: "Using github-pr-review".
- Then output exactly the review skill's markdown block.
- Do not add extra sections, summaries, or analysis outside the review skill output.
- Ensure the cleanup `rm -rf` command appears as a bullet under **Required Actions** in the review output (only the exact paths created).

## Reference
- Defer coverage guidance to the `review` skill.
