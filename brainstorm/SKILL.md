---
name: brainstorm
description: Requirements gathering, brainstorming, best-practice discussion, tool and approach exploration, and scope narrowing when the user is unsure or asks to discuss/brainstorm (e.g., "let's brainstorm", "let's discuss", "I'm not sure", "maybe we can", "should we perhaps", "would it be a good idea", "how can we"). Use to clarify ambiguous requests before planning or implementation.
---

# Brainstorm

## Workflow
1. Restate the goal and the known constraints.
2. Identify ambiguity that blocks progress.
   - If the request is vague, stop and ask focused clarifying questions.
   - Do not proceed until ambiguities that would change direction are resolved.
3. Before asking any questions, search the repository for answers (README, docs, configs, and relevant code). Prefer `rg` to locate clues and cite file paths in your response.
4. Avoid assumptions.
   - Never choose a language, framework, third-party library, or API without explicit user direction.
   - If a decision is required, ask for it. Only proceed when the user grants explicit liberty.
5. Brainstorm options once the problem is concrete enough.
   - Offer 2–4 options with tradeoffs, risks, and decision points.
   - Present best practices and tools as optional choices, not defaults.
6. Narrow scope and requirements.
   - Draft functional requirements (Must/Should/Could).
   - Draft non-functional requirements (performance, reliability, security, UX, timeline).
   - Define in-scope and out-of-scope.
   - List open questions or risks that still need answers.
7. Gate to planning.
   - When requirements are stable, ask exactly:
     1. Would you like to proceed to planning?
     2. Refine the requirements further

## Hard Stops
- If it is impossible to proceed without assumptions (e.g., language, framework, libraries, APIs, integrations, best practices), stop and ask for clarification.
- If the user is vague about goals, users, data, or success criteria, stop and ask for details.

## Response format
If clarification is required, only ask questions and wait for answers.
Always present questions as a numbered list so the user can respond point-by-point.
Otherwise, respond in this order:
1. Goal recap
2. Constraints (confirmed only)
3. Options with tradeoffs
4. Draft requirements (Must/Should/Could)
5. Scope (In / Out)
6. Open questions
7. Next-step prompt (the two exact options)
