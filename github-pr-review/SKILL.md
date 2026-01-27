---
name: github-pr-review
description: Thorough GitHub pull request review from a PR URL, including diff analysis against the target base branch, code quality, potential bugs, critical errors, and consistency with the existing codebase.
---

# GitHub PR Review

## Inputs
- GitHub PR URL (required).

## Workflow
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
3. Inspect changed files and surrounding context.
   - Read the patched files in the working tree and compare with the base where needed (`git show origin/<baseRefName>:path` or `git diff -U` for more context).
   - Use `rg` to find related patterns, similar implementations, or required invariants.
4. Review for correctness, quality, and consistency.
   - Verify logic, edge cases, error handling, data validation, concurrency, security, and performance.
   - Check for API/contract changes, backward compatibility, migrations, and configuration updates.
   - Ensure style and architectural consistency with existing codebase patterns.
   - Verify tests are updated or added where needed and note missing coverage.
5. Produce findings in the required output format.
6. Manual cleanup notes.
   - Never execute `rm -rf`.
   - Record every temp path created and include them only in the "Manual cleanup" `rm -rf` line.
   - Provide a copy-pastable `rm -rf` command that deletes only the exact paths created.

## Output format
- Start with a brief PR summary: title, base -> head, file count, and change size if available. Keep this summary unchanged.
- Replace any table output with a per-finding structured block:

  Finding <N>

  - Severity: <Critical|High|Medium|Low|Info>
  - Category: <Bug|Security|Performance|Correctness|Quality|Consistency|Tests|Docs>
  - Location: <file path with line(s)>
  - Issue: <short description>
  - Evidence: <specific diff/context>
  - Recommendation: <concrete fix>
  - Suggested fix:

    ```<language>
    <small, localized snippet>
    ```

  Only include the "Suggested fix" block when a safe, minimal snippet is possible. If no safe snippet exists, omit the "Suggested fix" section.

- If there are no findings, output "No issues found" and list what was reviewed plus any residual risks.
- End with suggested tests or verification steps if applicable. Keep this section unchanged.
- Add a "Manual cleanup" section that includes only a copy-pastable `rm -rf` command with backslash line breaks between paths. Do not run the command or list the paths separately.
  - Use this exact shape (not in a code block): `rm -rf <path1> \` on the first line, then one `<path>` per line with trailing `\` until the last path.

## Reference
- Use `references/review-checklist.md` to ensure comprehensive coverage.
