---
name: execute-plan
description: Execute a stored implementation plan step-by-step. Use when the user asks to run/execute a plan, proceed after planning, follow a docs/plans/*.md plan, or do the next step from an implementation plan, with TDD, chunked delivery, and commits after each chunk.
---

# Execute Plan

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using execute-plan".
0. Confirm explicit approval to execute a specific plan.
   - If the user has not explicitly approved execution, stop and ask for approval.
   - If multiple plans exist, ask which one to execute before proceeding.
1. Locate the plan source.
   - If the user provides a plan path, open that file.
   - If the user provides a plan in the conversation, use it as the source of truth (offer to persist it under docs/plans/).
   - Otherwise, search `docs/plans/*.md` and ask the user to pick a plan if more than one exists.
   - If no plan exists, stop and ask whether to create one (use the implementation-plan skill) or request the plan text.
2. Read the plan end-to-end and briefly summarize (1–4 bullets):
   - Goals and non-goals
   - Step-by-step plan
   - Files to touch
   - Testing/verification requirements
3. Validate the plan against the repo.
   - If a referenced file, API, or dependency does not exist, or a step conflicts with the repo, stop and ask for clarification.
   - Repo-first: if the repo already dictates a choice (framework/tooling), use it and only ask for confirmation if evidence conflicts.
   - Preflight scan before questions: check repo docs, configs, templates, scripts, and conventions; cite paths in your response.
4. Split the plan into delivery chunks.
   - Prefer 1–3 plan steps per chunk.
   - Each chunk must be testable and end with a commit.
5. Prepare an isolated worktree and branch before executing.
   - Use the worktree-setup skill for setup.
   - Capture and retain the outputs for handoff: base branch, worktree path, branch name.
   - If the skill is unavailable, stop and ask how to proceed.
6. Execute each chunk with TDD (default) and commit.
   - Before claiming a chunk is complete or tests are passing, use the verification-before-completion skill to run and report fresh verification evidence.
7. After completing the plan, ask the user to choose exactly one finalization path:
   1) Push branch to remote and open a PR using `gh pr create`, then use worktree-cleanup to clean up.
   2) Merge locally to `main` (or repo default branch) using rebase, then use worktree-cleanup to clean up.
   3) Discard all changes, then use worktree-cleanup to clean up.

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
 - If the user explicitly requests a commit (with or without a push), invoke the git-stage-commit skill and let it drive the commit workflow first.

## PR hygiene (required for PR path)
- Before `gh pr create`, locate any PR template in the target repo and follow it.
  - Common locations: `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, `.github/pull_request_template/`.
- Ensure the description is comprehensive and reduces reviewer cognitive load.
  - Start with a clear goal statement: `This PR aims to ...`.
  - Explain what feature it implements or issue it resolves.
  - Summarize scope of changes and what reviewers should focus on.
  - List tests/verification run and expected behavior changes.
  - Call out risks, migrations, or rollout notes when relevant.
  - Include screenshots/logs for UI or behavioral changes when applicable.
- If required information is missing, stop and ask the user before creating the PR.
  - Ask only one missing-info question at a time.

## Worktree + branch lifecycle
- Use the worktree-setup skill to create the worktree/branch.
- Use the worktree-cleanup skill to clean up the worktree/branch after finalization.
- Always work inside the new worktree; do not edit the main working tree.
- If the user selects PR:
  - Push the branch to `origin`.
  - Apply PR hygiene requirements (template + comprehensive description) before `gh pr create`.
  - Require `gh pr create`; if `gh` is missing or unauthenticated, stop and ask the user to fix it.
  - Check GitHub Actions/PR checks:
    - If checks exist, they must pass before any PR merge.
    - If checks are failing or pending, stop and ask whether to wait or to systematically debug.
- If the user selects local merge:
  - Rebase the branch onto the default branch, then fast-forward the default branch to the rebased HEAD.
- If the user selects discard:
  - Skip PR/merge steps and proceed to cleanup.
- After finalization, invoke worktree-cleanup for the chosen path.

## Worktree handoff contract (required)
When invoking worktree-setup, provide:
- Setup: task topic, change type, base branch (or allow detection), and worktree path if mandated.

When invoking worktree-cleanup, provide:
- Cleanup: worktree path, branch name, and outcome (`merged` or `discarded`).

Example handoff (cleanup):
```
Use worktree-cleanup with:
- worktree path: ../wt-user-registration
- branch name: feat/user-registration
- outcome: merged
```

## Hard stops (must ask the user)
- Plan is missing, ambiguous, or contradicts repository reality.
- No explicit approval to execute the plan.
- Tests are already failing before changes (do not proceed until resolved).
- The plan requires a framework, dependency, or tool not present in the repo.
- A step would require skipping the TDD loop in a code repository.
- User requests PR merge while required checks are failing or pending.

## Systematic debug option
If CI checks fail or are flaky:
- Ask the user whether to start a systematic debug flow.
- Use the systematic-debugging skill.

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
 - If a completion claim is made, include verification evidence per verification-before-completion.

## Concise response default
- Default to 1–4 bullets or 2–5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.

## Question policy
- Ask at most one blocking question at a time.
- Prefer repo evidence over user preferences when the repo already dictates a choice.
- Use questions to confirm repo-derived decisions only when evidence is conflicting or ambiguous.

## Finalization prompt (required)
After the last chunk, ask the user to choose:
1) Push branch + PR
2) Merge locally to default branch
3) Discard changes
