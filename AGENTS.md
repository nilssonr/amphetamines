# Agent Instructions (Amphetamine Skills)

This repo defines Codex skills that enforce consistent, safe, and high-quality workflows. Treat this repo as the source of truth for skills and their behavior.

## Intent
- Optimize for clarity, repeatability, and safety.
- Prefer explicit, action-oriented rules and unambiguous defaults.
- Favor repo evidence over assumptions.

## Skills are the product
- Keep skill behavior consistent with the skill's `SKILL.md`.
- If a workflow needs deterministic steps, prefer scripts in `scripts/` and reference them in `SKILL.md`.
- Do not add extra docs outside of SKILL.md (no README/CHANGELOG/extra guides).

## Standard behavior for all skills
- Every skill response must begin with: `Using <skill-name>`.
- If a skill has an output format, follow it exactly.
- Keep responses concise unless the skill explicitly requires a longer format.

## Workflow rules
- Never edit `~/.codex/skills` directly.
- Use `make install` after any skill changes to sync updates.

## Delegation and ownership
- `review` performs **all** review logic and outputs the review format.
- `github-pr-review` only acquires the PR, manages local lifecycle, and hands off to `review`.
- `execute-plan` must use:
  - `worktree-setup` / `worktree-cleanup` for isolation
  - `verification-before-completion` before any completion claim
  - `testing-anti-patterns` when writing or changing tests/mocks
- `implementation-plan` should use `worktree-setup` before writing plan files to disk.

## Change guidelines
- Keep instructions explicit; spell out defaults and fallbacks.
- Prefer objective enforcement (formatters, tests, validation commands).
- When modifying a skill, update its scripts and references if impacted.
