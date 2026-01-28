---
name: git-stage-commit
description: Stage and commit code in small, meaningful batches while implementing a plan, or whenever the user requests commits (even if combined with other tasks like pushing). Use to run git status/diff, stage appropriate files, and create Conventional Commit messages with optional scopes.
---

# Git Stage + Commit

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using git-stage-commit" followed by a blank line.
0. If the user requested a commit as part of a larger request, complete the commit workflow first, then return to the remaining tasks (e.g., push).
1. Confirm you are in a git repo and identify changed files.
2. Preflight scan before questions: if you need information to decide how to scope commits, search the repo first (README, docs, config, module manifests). Prefer `rg` and cite file paths in your response.
   - Repo-first: if the repo already dictates a choice (module name or scope), use it and only ask for confirmation if evidence conflicts.
3. Group changes into small, meaningful batches that reflect a single intent. Do not split excessively; each commit should still make sense as a unit.
4. Stage the batch with `git add` (or `git add -p` if needed) and review the staged diff.
5. Compose a Conventional Commit message (scope optional). Never include emojis.
6. Run `git commit -m "<message>"` automatically.
7. Repeat as the implementation progresses or when the user requests a commit.

## When to commit
- During implementation, after completing a coherent change or step.
- When the user asks to commit (e.g., "please commit these changes we've made"), even if other tasks are requested too.
  - If the user also asked to push, push only after this workflow completes.

## Conventional Commit rules
- Format: `type(scope): summary` or `type: summary` when scope is not reasonable.
- Use a scope if a clear top-level package/dir or module name applies to the staged files.
- If files span multiple top-level dirs or no clear module exists, omit the scope.
- No emojis.

## Scope selection heuristic
Use a scope only when it is obvious and consistent for all staged files.
1. If all staged files are under a single top-level directory, use that directory name as the scope.
2. Else, if the repo has a single clear module name, use it:
   - Node: `package.json` -> `name`
   - Python: `pyproject.toml` -> `[project].name`
   - Go: `go.mod` -> `module`
   - Rust: `Cargo.toml` -> `[package].name`
3. Otherwise, omit the scope.

## Type selection (default)
Use standard Conventional Commit types unless the repo defines a stricter list:
- `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`, `style`, `revert`

## Safety and integrity
- Do not commit unrelated or partially broken changes.
- Prefer separate commits for unrelated intents.
- If staging would include unrelated edits, split the commit or ask for guidance.

## Commands to use
- Inspect: `git status -sb`, `git diff`, `git diff --staged`
- Stage: `git add <paths>` or `git add -p`
- Commit: `git commit -m "type(scope): summary"`

## Concise response default
- Default to 1–4 bullets or 2–5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.

## Question policy
- Ask at most one blocking question at a time.
- Prefer repo evidence over user preferences when the repo already dictates a choice.
- Use questions to confirm repo-derived decisions only when evidence is conflicting or ambiguous.
