---
name: github-pr-review
description: Thorough GitHub pull request review from a PR URL, including diff analysis against the target base branch, code quality, potential bugs, critical errors, and consistency with the existing codebase.
---

# GitHub PR Review

## Inputs
- GitHub PR URL (required).

## Workflow
1. Resolve PR metadata.
   - Prefer GitHub CLI: `gh pr view <url> --json number,title,baseRefName,headRefName,repository,headRepository,files,commits,author,createdAt`.
   - If `repository` is unavailable, parse the PR URL to extract owner/repo/number.
   - If `gh` is unavailable, parse the PR URL to extract owner/repo/number. Ask the user to provide one of: (a) `gh` access, (b) a patch/diff file, or (c) the base branch name plus the head branch or commit SHA.
2. Fetch the correct diff against the target branch.
   - Use `gh pr diff <url>` to obtain the unified diff against the PR base.
   - For deeper inspection, checkout the PR head: `gh pr checkout <url>` and diff against the base ref: `git fetch origin <baseRefName>` then `git diff origin/<baseRefName>...HEAD`.
   - If the PR is from a fork, ensure remotes for both base and head repos; rely on `gh pr checkout` when possible.
   - Always work in a temporary directory under `/tmp` (e.g., `/tmp/gh-pr-review-<repo>-<number>`), and avoid using the user's existing working trees.
   - Prefer using `scripts/review_pr.sh` to create the temp workspace, clone the base repo, checkout the PR head, and generate a diff with automatic cleanup.
3. Inspect changed files and surrounding context.
   - Read the patched files in the working tree and compare with the base where needed (`git show origin/<baseRefName>:path` or `git diff -U` for more context).
   - Use `rg` to find related patterns, similar implementations, or required invariants.
4. Review for correctness, quality, and consistency.
   - Verify logic, edge cases, error handling, data validation, concurrency, security, and performance.
   - Check for API/contract changes, backward compatibility, migrations, and configuration updates.
   - Ensure style and architectural consistency with existing codebase patterns.
   - Verify tests are updated or added where needed and note missing coverage.
5. Produce findings in the required output format.
6. Cleanup.
   - Delete the temporary directory and any cloned repositories after the review completes (success or failure).

## Output format
- Start with a brief PR summary: title, base -> head, file count, and change size if available.
- List each finding separately with these fields:
  - Severity: Critical | High | Medium | Low | Info
  - Category: Bug | Security | Performance | Correctness | Quality | Consistency | Tests | Docs
  - Location: file path and line(s) when possible
  - Issue: what is wrong and why it matters
  - Evidence: cite relevant diff/context
  - Recommendation: concrete fix or mitigation
- If no findings, state "No issues found" and list what was reviewed plus any residual risks.
- End with suggested tests or verification steps if applicable.

## Reference
- Use `references/review-checklist.md` to ensure comprehensive coverage.
