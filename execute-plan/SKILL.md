---
name: execute-plan
description: Execute a stored implementation plan step-by-step. Use when the user asks to run/execute a plan, proceed after planning, follow a docs/plans/*.md plan, or do the next step from an implementation plan, with TDD, chunked delivery, and commits after each chunk.
---

# Execute Plan

## Workflow
1. Locate the plan source.
   - If the user provides a plan path, open that file.
   - If the user provides a plan in the conversation, use it as the source of truth (offer to persist it under docs/plans/).
   - Otherwise, search `docs/plans/*.md` and ask the user to pick a plan if more than one exists.
   - If no plan exists, stop and ask whether to create one (use the implementation-plan skill) or request the plan text.
2. Read the plan end-to-end and restate:
   - Goals and non-goals
   - Step-by-step plan
   - Files to touch
   - Testing/verification requirements
3. Validate the plan against the repo.
   - If a referenced file, API, or dependency does not exist, or a step conflicts with the repo, stop and ask for clarification.
4. Split the plan into delivery chunks.
   - Prefer 1–3 plan steps per chunk.
   - Each chunk must be testable and end with a commit.
5. Prepare an isolated worktree and branch before executing.
   - Derive a short branch name from the plan title using Conventional Commit style: `<type>/<kebab-topic>` (e.g., `feat/user-registration`).
   - Create a sibling worktree directory (e.g., `../wt-<plan-name>`).
   - Create and check out the new branch inside the worktree.
   - If worktree/branch creation fails, stop and ask the user how to proceed.
6. Execute each chunk with TDD (default) and commit.
7. After completing the plan, ask the user to choose exactly one finalization path:
   1) Push branch to remote and open a PR using `gh pr create`, then delete local branch and worktree.
   2) Merge locally to `main` (or repo default branch) using rebase, then delete branch and worktree.
   3) Discard all changes, delete branch and worktree.

## TDD loop (default for code repositories)
- Before writing production code, create or update tests for the chunk.
- Run tests to confirm a failure tied to the new behavior. If the test passes unexpectedly, fix the test until it fails for the right reason.
- Implement the smallest change to pass the test.
- Re-run tests until green.
- Only then proceed to the next chunk.

## TDD exceptions (skip tests only when applicable)
Skip TDD only for:
- Configuration-only repos (no executable code)
- Kubernetes manifests / infrastructure-only repos
- Documentation-only repos

For exceptions, run the best available validation step (lint, schema checks, `kubectl` dry-run, `make validate`, etc.). If no validation is defined, stop and ask for the preferred verification approach.

## Commit rules
- Commit after each chunk is complete and verified.
- Stage only the files touched by the chunk.
- Use Conventional Commit messages. If the git-stage-commit skill is available, follow it.

## Worktree + branch lifecycle
- Always work inside the new worktree; do not edit the main working tree.
- Default to `main` as the base branch. If the repo default is different, detect it and use that.
- If the user selects PR:
  - Push the branch to `origin`.
  - Require `gh pr create`; if `gh` is missing or unauthenticated, stop and ask the user to fix it.
  - Check GitHub Actions/PR checks:
    - If checks exist, they must pass before any PR merge.
    - If checks are failing or pending, stop and ask whether to wait or to systematically debug.
  - After confirmation, delete the local branch and remove the worktree.
- If the user selects local merge:
  - Rebase the branch onto the default branch, then fast-forward the default branch to the rebased HEAD.
  - After confirmation, delete the local branch and remove the worktree.
- If the user selects discard:
  - Remove the worktree and delete the local branch without merging.
- Always remove the worktree directory after finalization, regardless of path.

## Hard stops (must ask the user)
- Plan is missing, ambiguous, or contradicts repository reality.
- Tests are already failing before changes (do not proceed until resolved).
- The plan requires a framework, dependency, or tool not present in the repo.
- A step would require skipping the TDD loop in a code repository.
- Unable to determine default branch or worktree creation fails.
- User requests PR merge while required checks are failing or pending.

## Systematic debug option
If CI checks fail or are flaky:
- Ask the user whether to start a systematic debug flow.
- If a debug skill is available, use it; otherwise offer to create a dedicated skill for CI debugging.

## Plan drift handling
If the plan needs to change to fit the repo:
- Explain the mismatch.
- Propose a minimal plan adjustment.
- Ask the user to approve the change (or update the plan) before continuing.

## Response expectations after each chunk
- Files changed
- Tests/validation run and results
- Commit message
- Next chunk to execute

## Finalization prompt (required)
After the last chunk, ask the user to choose:
1) Push branch + PR
2) Merge locally to default branch
3) Discard changes
