---
name: brainstorm
description: Requirements gathering and option exploration only when the user explicitly asks to brainstorm/discuss alternatives or expresses uncertainty (e.g., "let's brainstorm", "I'm not sure", "maybe we can", "should we perhaps"). Do not use when the user provides explicit requirements, directives, or corrections.
---

# Brainstorm

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
0. Triage before brainstorming.
   - If the user provides explicit requirements, directives, or corrections, do **not** run a full brainstorm.
   - Instead, acknowledge the requirement and propose concrete edits or next steps in a concise response.
1. Restate the goal and the known constraints (confirmed only).
2. Identify ambiguity that blocks progress.
   - If the request is vague, stop and ask focused clarifying questions.
   - Do not proceed until ambiguities that would change direction are resolved.
3. Preflight scan before questions: search the repository for answers (README, docs, configs, templates, and relevant code). Prefer `rg` and cite file paths in your response.
4. Avoid assumptions.
   - Never choose a language, framework, third-party library, or API without explicit user direction.
   - Repo evidence counts as explicit direction for existing choices already present in the codebase.
   - If a decision is required, ask for it. Only proceed when the user grants explicit liberty.
   - Repo-first: if the repository already shows the choice (framework/tooling), use it and only ask for confirmation if there is conflicting evidence.
5. Brainstorm options **only if the user asked for options** or uncertainty remains.
   - Offer 2–4 options with tradeoffs, risks, and decision points.
   - Present best practices and tools as optional choices, not defaults.
6. Narrow scope and requirements **only if needed**.
   - Draft functional requirements (Must/Should/Could).
   - Draft non-functional requirements (performance, reliability, security, UX, timeline).
   - Define in-scope and out-of-scope.
   - List open questions or risks that still need answers.
7. Gate to planning **only if the user asked to plan**.
   - Otherwise, end after providing the requested guidance or edits.

## Hard Stops
- If it is impossible to proceed without assumptions (e.g., language, framework, libraries, APIs, integrations), stop and ask for clarification.
- If the user is vague about goals, users, data, or success criteria, stop and ask for details.

## Response format
If clarification is required, only ask questions and wait for answers.
- Use a numbered list only when asking multiple questions; otherwise ask a single question plainly.
- Ask at most one blocking question; do not ask preference questions when the repo already indicates the answer.
If the user provided explicit requirements or corrections, respond concisely in this order:
1. Acknowledge and restate the requirement (1–2 sentences).
2. Proposed skill edits or guidance (short bullets).
3. Offer to implement the changes (single question).
Otherwise, respond in this order:
1. Goal recap
2. Constraints (confirmed only)
3. Options with tradeoffs (only if requested)
4. Draft requirements (Must/Should/Could) (only if needed)
5. Scope (In / Out) (only if needed)
6. Open questions (only if needed)
7. Next-step prompt (only if planning was requested)

## Concise response default
- Default to 1–4 bullets or 2–5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.
