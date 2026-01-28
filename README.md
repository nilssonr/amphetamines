# Amphetamine: Codex Skills

This repository defines Codex skills that enforce consistent, safe, and high-quality workflows. It is the source of truth for all skill behavior and packaging.

## Quick start

```bash
make list
make install
```

`make install` packages the skills and syncs them into `~/.codex/skills` (or `SKILLS_HOME`). Never edit `~/.codex/skills` directly.

## Requirements

- Codex configured to read from `~/.codex/skills` (or `SKILLS_HOME`).
- `make`, `rsync`, and `zip` available on your PATH.
- Some skills require external tools (see each skill's `SKILL.md`).

## Skill catalog

Each skill lives in its own directory with a `SKILL.md` and optional `scripts/` or `references/`.
All skills announce themselves by starting responses with `Using <skill-name>`.

| Skill | What it does (short) |
| --- | --- |
| `brainstorm` | Requirements gathering and option exploration when asked or uncertainty exists. |
| `implementation-plan` | Produces a TDD-driven plan file with exact steps, commands, and code. |
| `execute-plan` | Executes a plan in chunks with TDD, verification, and structured commits. |
| `git-stage-commit` | Stages changes and writes Conventional Commits in small, coherent batches. |
| `worktree-setup` | Creates an isolated worktree + branch (scripted). |
| `worktree-cleanup` | Removes worktree + branch after merge or discard (scripted). |
| `github-pr-review` | Fetches PR code locally and hands off to `review`. No review logic. |
| `review` | Quality gatekeeper: structured review with non-negotiable merge gates. |
| `systematic-debugging` | Four-phase root-cause debugging flow for bugs and failures. |
| `verification-before-completion` | Requires fresh verification evidence before completion claims. |
| `testing-anti-patterns` | Prevents mock abuse and test-only production changes. |
| `test-driven-development` | Test-first (red-green-refactor) workflow and exceptions guidance. |
| `typescript-best-practices` | Applies Google TypeScript Style Guide best practices for TS/TSX code. |
| `markdown-style-guide` | Applies Markdown style guide best practices for documentation. |

## Workflow (end-to-end)

1. **Clarify requirements**
   - Use `brainstorm` when requirements are unclear or alternatives are requested.
2. **Set up isolation (when persisting plans)**
   - `implementation-plan` uses `worktree-setup` before writing a plan file to disk.
3. **Create an implementation plan**
   - Use `implementation-plan` to generate a TDD-first plan file in `docs/plans/` inside the worktree.
4. **Set up isolation for execution**
   - `execute-plan` invokes `worktree-setup` to create a clean worktree/branch.
5. **Implement in chunks**
   - Follow the plan step-by-step with TDD.
   - Invoke `testing-anti-patterns` when tests or mocks are involved.
   - Apply `typescript-best-practices` when changing TypeScript/TSX code.
   - Apply `markdown-style-guide` when changing Markdown documentation.
   - Use `verification-before-completion` before claiming any step is done.
6. **Commit coherently**
   - `execute-plan` uses `git-stage-commit` for Conventional Commits per chunk.
7. **Handle failures correctly**
   - Use `systematic-debugging` for test failures, bugs, and flaky CI.
8. **Review PRs**
   - `github-pr-review` only fetches the PR and provides base/head/diff context.
   - `review` performs the full review and outputs the structured decision.
9. **Clean up**
   - `execute-plan` invokes `worktree-cleanup` after merge or discard.

## Repository layout

- `*/SKILL.md` - skill definitions and workflow rules.
- `*/scripts/` - deterministic helpers referenced by skills.
- `references/` - shared reference materials.
- `dist/` - packaged `.skill` artifacts from `make package`.
- `AGENTS.md` - repo-wide instructions for agents.
- `Makefile` - packaging and install targets.

## Common commands

List skills:

```bash
make list
```

Install skills locally (runs `make package` first):

```bash
make install
```

Build distributable bundles:

```bash
make package
```

Clean build artifacts:

```bash
make clean
```

Uninstall skills from the Codex skills directory:

```bash
make uninstall
```

## Development guidance

- Keep `SKILL.md` and any supporting scripts aligned.
- Prefer explicit defaults and objective checks over subjective guidance.
- Update scripts when behavior becomes deterministic or repetitive.
- After changes, run `make install` to sync.

## Troubleshooting

- If Codex is not picking up changes, confirm `make install` completed and `SKILLS_HOME` is correct.
- If a skill depends on an external tool (e.g., `gh`), install it and retry.
