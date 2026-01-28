---
name: implementation-plan
description: Turn brainstorming outcomes or rough ideas into thorough, step-by-step implementation plans in Markdown. Use when the user asks to break down a larger task, produce an implementation plan, or persist a plan under docs/plans with code snippets per file.
---

# Implementation Plan

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using implementation-plan".
1. Restate the goal and confirmed constraints from the user or prior brainstorming output.
2. Identify missing inputs that would change the plan (APIs, frameworks, data sources, success criteria).
3. Preflight scan before questions: search the repository for answers (README, docs, config, templates, existing plans, and relevant code). Prefer `rg` to locate clues and cite file paths in your response.
   - Repo-first: if the repository already shows the choice (framework/tooling), use it and only ask for confirmation if there is conflicting evidence.
4. Ask concise questions only if the repository does not answer them.
5. Persist the plan by default.
   - Persist to `docs/plans/` unless the user explicitly asks for a chat-only plan.
6. If persisting, create a worktree before writing the plan file.
   - Use `worktree-setup` with change type `chore` and topic derived from the plan title, unless the user specifies otherwise.
   - Create the plan file inside the worktree, not the main working tree.
   - If worktree setup fails or is unavailable, stop and ask how to proceed.
7. Determine the plan filename under `<REPO_ROOT>/docs/plans/`.
   - If the user provides a name, use it.
   - Otherwise use `YYYY-MM-DD-<kebab-title>.md` (ISO date).
8. Ensure `<REPO_ROOT>/docs/plans/` exists; create it if needed.
9. Prefer `scripts/init_plan.sh` to scaffold the plan file, then fill in all required sections.
10. Write the Markdown plan file with the required sections and code blocks per file.
11. If the user explicitly requests a commit (with or without a push), invoke the git-stage-commit skill and let it drive the commit workflow first.

## Repository modification rules
- Do **not** modify existing code or config during planning.
- The **only** allowed repo change in this skill is creating a plan file in `docs/plans/`.
- When persisting, create the plan file inside the worktree created by `worktree-setup`.
 
## TDD requirement
- For deeper TDD guidance and rationale, use the test-driven-development skill.
- The plan must be **strictly TDD-driven**, unless a documented TDD exception applies.
- For every implementation step, specify:
  1) the **test** to write (and exact file change),
  2) the **test command** to run and the **expected failing outcome**,
  3) the **implementation change** to make the test pass,
  4) the **re-run** of tests to confirm pass (with **expected passing output**),
  5) the **commit** (exact git commands).
- Do not plan implementation work without an explicit preceding failing test, unless a TDD exception applies.
- TDD exceptions mirror execute-plan: config-only, infra-only (e.g., Kubernetes manifests), docs-only, and simple script-only changes where tests are disproportionate (single-file change, small surface area, no branching business logic, no external integrations).
- For exceptions, replace test steps with the best available verification command (lint, schema check, dry-run, or deterministic invocation). If verification is unclear from the repo, stop and ask; do not invent commands or outputs.
- When proposing tests or mocks, apply the testing-anti-patterns skill before finalizing the plan.

## Required content
Include all sections below, in this order. Keep prose clear and action-oriented.

1. **Title + Plan Header**
   - Must include:
     - **Goal:** one sentence
     - **Architecture:** 2-3 sentences
     - **Tech Stack:** key tools/libraries
     - **Execution:** Use the execute-plan skill in this session
2. **Context**
   - Summarize the brainstorming outcome and key decisions.
3. **Goals**
4. **Non-goals**
5. **Assumptions & Constraints**
6. **Step-by-step Plan** (numbered)
   - Each task should be bite-sized (2-5 minutes) and a single action; split if larger.
   - Each task must name the files it touches.
   - Each task must follow the TDD sequence: test → run/fail → implement → run/pass → commit.
   - Each run step must include the exact command and the expected output.
7. **Implementation Details (by file)**
   - A section per file with the exact code to add/change.
8. **Testing & Verification**
9. **Risks / Open Questions**
10. **Acceptance Checklist**
11. **Execution Handoff**
    - A short prompt to proceed with execute-plan in this session.

## Code inclusion rules
- Provide concrete code for every file mentioned in the plan.
- Use fenced code blocks with language tags when possible.
- For edits to existing files, prefer `diff` blocks.
- For new files, include the full file content.
- If a required code detail is unclear, stop and ask questions; do not invent APIs or data.
 - Test code must appear **before** implementation code in the plan file.

## Default plan filename
- If persisting and no filename is provided, create:
  - `docs/plans/YYYY-MM-DD-<kebab-title>.md`

## Plan template
Use this exact structure as a starting point:

```markdown
# <Title>

**Goal:** <One sentence describing what this builds>
**Architecture:** <2-3 sentences about approach>
**Tech Stack:** <Key technologies/libraries>
**Execution:** Use the execute-plan skill in this session

## Context
<Brief summary of the brainstormed idea and decisions.>

## Goals
- <Goal 1>
- <Goal 2>

## Non-goals
- <Non-goal 1>

## Assumptions & Constraints
- <Assumption or constraint>

## Step-by-step Plan
1. <Task name>
   - Step 1: Write the failing test (files: <path>)
   - Step 2: Run tests (expect fail)
     - Command: `<exact command>`
     - Expected: <exact failure output>
   - Step 3: Write the minimal implementation (files: <path>)
   - Step 4: Run tests (expect pass)
     - Command: `<exact command>`
     - Expected: <exact pass output>
   - Step 5: Commit
     - Commands: `git add <paths>`; `git commit -m "<type>: <summary>"`

## Implementation Details (by file)

### <path/to/file.ext>
```diff
@@
-<old>
+<new>
```

### <path/to/new-file.ext>
```<language>
<full file contents>
```

## Testing & Verification
- <Command or manual check>

## Risks / Open Questions
- <Risk or question>

## Acceptance Checklist
- [ ] <Criterion>

## Execution Handoff
Ready to proceed with execute-plan in this session?
```

## Quality checks
- Ensure every step has corresponding code in the file sections.
- Ensure no file appears without code.
- Ensure each test run includes an exact command and expected output.
- Ensure each task ends with an explicit commit step.
- Keep the plan actionable and specific; avoid vague tasks.

## Concise response default
- In chat responses, default to 1–4 bullets or 2–5 short sentences.
- If the plan is not being persisted (user explicitly asked for chat-only), include the full plan in chat and keep extra commentary minimal.
- If the plan is persisted (default), do **not** output the full plan in chat; provide a generalized summary only.
- Always finish persisted-plan responses with options:
  1. Proceed to execute the plan.
  2. Brainstorm more to resolve ambiguities, conflicts, or errors.
  3. Discard the plan.
- Do not use multi-section outputs unless explicitly requested beyond the plan content.
- Ask at most one blocking question and stop.

## Question policy
- Ask at most one blocking question at a time.
- Prefer repo evidence over user preferences when the repo already dictates a choice.
- Use questions to confirm repo-derived decisions only when evidence is conflicting or ambiguous.
