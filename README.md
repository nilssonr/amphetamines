# Codex Skills: Amphetamine

This repository contains Codex agent skills. The goal is to provide reliable, reusable workflows that help Codex make coherent decisions and operate consistently across projects.

## Quick start

```bash
make list
make install
```

`make install` builds bundled artifacts and syncs the skills into `~/.codex/skills` (or the directory set by `SKILLS_HOME`). Do not edit `~/.codex/skills` directly; treat this repo as the source of truth.

## Requirements

- Codex (configured to read skills from `~/.codex/skills`).
- `make`, `rsync`, and `zip` on your PATH.
- For specific skills, additional tools may be required (see each skill's `SKILL.md`).

## Repository layout

- `github-pr-review/` — skill source: `SKILL.md`, scripts, and references.
- `dist/` — packaged `.skill` artifacts produced by `make package`.
- `AGENTS.md` — agent instructions for this repo.
- `Makefile` — packaging and installation utilities.

## Common workflows

List skills:

```bash
make list
```

Install skills locally (required after changes; runs `make package` first):

```bash
make install
```

Build distributable skill bundles:

```bash
make package
```

Clean build artifacts:

```bash
make clean
```

Uninstall installed skills from your Codex skills directory:

```bash
make uninstall
```

## Development guidance

- Keep `SKILL.md` and any scripts in the same skill folder aligned.
- Prefer explicit, action-oriented instructions in skill docs.
- Reuse templates and scripts already present in the skill directory.
- After modifying a skill, run `make install` so Codex uses the updated version.

## Skill catalog

Current skills are listed via `make list`. Each skill includes its own documentation in its `SKILL.md` file with usage instructions and required inputs.

## Troubleshooting

- If Codex is not picking up changes, confirm `make install` completed and your `SKILLS_HOME` points to the correct directory.
- If a skill depends on an external tool (e.g., `gh`), install that tool and re-run the workflow.
