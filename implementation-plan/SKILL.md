---
name: implementation-plan
description: Turn brainstorming outcomes or rough ideas into thorough, step-by-step implementation plans in Markdown. Use when the user asks to break down a larger task, produce an implementation plan, or persist a plan under docs/plans with code snippets per file.
---

# Implementation Plan

## Workflow
1. Restate the goal and confirmed constraints from the brainstorming output.
2. Identify missing inputs that would change the plan (APIs, frameworks, data sources, success criteria).
3. Before asking any questions, search the repository for answers (README, docs, config, existing plans, and relevant code). Prefer `rg` to locate clues and cite file paths in your response.
4. Ask concise questions only if the repository does not answer them.
5. Determine the plan filename under `<REPO_ROOT>/docs/plans/`.
   - If the user provides a name, use it.
   - Otherwise use `YYYY-MM-DD-<kebab-title>.md` (ISO date).
6. Ensure `<REPO_ROOT>/docs/plans/` exists; create it if needed.
7. Write a Markdown plan file with the required sections and code blocks per file.

## Required content
Include all sections below, in this order. Keep prose clear and action-oriented.

1. **Title**
2. **Context**
   - Summarize the brainstorming outcome and key decisions.
3. **Goals**
4. **Non-goals**
5. **Assumptions & Constraints**
6. **Step-by-step Plan** (numbered)
   - Each step must name the files it touches.
7. **Implementation Details (by file)**
   - A section per file with the exact code to add/change.
8. **Testing & Verification**
9. **Risks / Open Questions**
10. **Acceptance Checklist**

## Code inclusion rules
- Provide concrete code for every file mentioned in the plan.
- Use fenced code blocks with language tags when possible.
- For edits to existing files, prefer `diff` blocks.
- For new files, include the full file content.
- If a required code detail is unclear, stop and ask questions; do not invent APIs or data.

## Default plan filename
- If no filename is provided, create:
  - `docs/plans/YYYY-MM-DD-<kebab-title>.md`

## Plan template
Use this exact structure as a starting point:

```markdown
# <Title>

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
1. <Step summary> (files: <path>, <path>)
2. <Step summary> (files: <path>)

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
```

## Quality checks
- Ensure every step has corresponding code in the file sections.
- Ensure no file appears without code.
- Keep the plan actionable and specific; avoid vague tasks.
