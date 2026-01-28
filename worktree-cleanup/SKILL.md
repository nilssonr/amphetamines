---
name: worktree-cleanup
description: Remove a git worktree and delete its branch after work is completed. Use when tearing down an isolated workspace after merge or discard.
---

# Worktree Cleanup

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
0. Confirm cleanup intent and required inputs.
   - Require: worktree path, branch name, and outcome (`merged` or `discarded`).
   - If any required input is missing, stop and ask for it.
1. Remove the worktree.
   - Run `git worktree remove <worktree-path>`.
   - If the remove fails, stop and ask how to proceed.
2. Delete the local branch.
   - If merged: `git branch -d <branch>`.
   - If discarded: `git branch -D <branch>`.
   - If deletion fails or would lose unmerged commits, stop and ask how to proceed.

## Required inputs
- Worktree path
- Branch name
- Outcome (`merged` or `discarded`)

## Hard stops
- Worktree path missing or ambiguous.
- Branch name missing or ambiguous.
- Outcome missing or unclear.
- Worktree remove fails.
- Branch deletion fails or would lose unmerged commits.

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.

## Question policy
- Ask at most one blocking question at a time.
- Prefer repo evidence over user preferences when the repo already dictates the answer.
- Use questions to confirm repo-derived decisions only when evidence is conflicting or ambiguous.
