---
name: verification-before-completion
description: Use before claiming work is complete, fixed, or passing, and before committing, pushing, or creating PRs. Requires fresh verification commands and evidence before any success claim.
---

# Verification Before Completion

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Core rule
No completion claim without fresh verification evidence in this message.

## Workflow
Start every response with: "Using verification-before-completion".
0. Identify the claim and required evidence.
   - What command proves the claim (tests, lint, build, migration, smoke check)?
   - If unclear from repo docs/config, ask for the exact command.
1. Run verification commands fresh.
   - Run the full command(s) now; do not rely on past output.
2. Read and summarize output.
   - Record exit code and key pass/fail summary (counts, failing tests, etc.).
3. Make the claim only with evidence.
   - If verification failed, state actual status with evidence.
   - If verification could not be run, state "Not verified" and ask for the correct command.

## Hard stops
- Do not claim success without fresh verification evidence.
- If the verification command is unknown or ambiguous, stop and ask for it.
- If the command cannot be run, explicitly state that the claim is unverified.

## Response format
- Keep it short and factual:
  - Command(s) run
  - Exit code
  - Evidence summary
  - Claim (only if verified)

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Ask at most one blocking question and stop.
