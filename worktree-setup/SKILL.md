---
name: worktree-setup
description: Create isolated git worktrees and branches for tasks. Use when a workflow needs an isolated workspace or when setting up a worktree+branch pair before executing a plan.
---

# Worktree Setup

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using worktree-setup" followed by a blank line.
0. Confirm intent and context.
   - Infer a short topic and change type from the user request or plan title.
   - Default change type to `feat` unless the request is clearly a bug fix (`fix`) or maintenance (`chore`).
   - Only ask a blocking question if you cannot infer a reasonable topic.
   - If the repo already defines a worktree path or naming convention, use it.
1. Ensure `.worktrees/` is present in `.gitignore`.
   - If missing, add it before proceeding.
2. Determine the base branch.
   - Prefer the remote default branch when available (e.g., `git symbolic-ref refs/remotes/origin/HEAD`).
   - If you cannot determine the base branch, stop and ask the user to specify it.
3. Create the worktree + branch.
   - Prefer `scripts/worktree_setup.sh` for deterministic setup.
   - Fetch latest refs before creating the branch.
   - Derive a short branch name using Conventional Commit style: `<type>/<kebab-topic>`.
   - Create the worktree directory under `.worktrees/<topic>` in the repo root.
   - Run `git worktree add -b <branch> <worktree-path> <base-ref>`.
   - If the path exists or the command fails, stop and ask how to proceed.
4. Working rule.
   - Do all edits inside the new worktree; do not modify the main working tree.
5. Output for handoff.
   - Provide: base branch, worktree path, branch name.

## Required inputs
- Task topic (infer if possible; only ask if you cannot infer).
- Change type (infer; default to `feat` when unclear).
- Base branch (or allow detection).
- Worktree path if the repo mandates one; otherwise default to `.worktrees/<topic>` under repo root.

## Hard stops
- Base branch cannot be determined.
- Worktree path already exists and is not clearly reusable.
- Worktree add fails.

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.

## Question policy
- Ask at most one blocking question at a time.
- Prefer repo evidence over user preferences when the repo already dictates the answer.
- Use questions to confirm repo-derived decisions only when evidence is conflicting or ambiguous.
