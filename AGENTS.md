# Agent Instructions

This repository contains Codex agent skills. The primary objective is to help Codex follow reliable workflows, extend its capabilities, and make coherent decisions while working on other projects.

## Scope and intent
- Treat this repo as the source of truth for all skill logic and documentation.
- Optimize for clarity, repeatability, and safety in skill behavior.
- Prefer changes that improve how Codex interprets instructions, sequences tasks, and reports results.

## Workflow rules
- Do not modify files under `~/.codex/skills` directly.
- The only allowed way to update installed skills is via `make install` in this repository.

## Change guidelines
- Keep instructions explicit and action-oriented.
- Avoid ambiguous wording; spell out defaults and fallbacks.
- Use repository-local scripts and templates when available.
- When updating a skill, also update its `SKILL.md` so the workflow and implementation stay aligned.
