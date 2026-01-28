---
name: systematic-debugging
description: Use for bugs, test failures, build/CI failures, unexpected behavior, or performance regressions. Run a root-cause-first four-phase debugging process before proposing fixes; no guessing or symptom-only patches.
---

# Systematic Debugging

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
0. Triage and scope.
   - If a language-specific triage skill clearly applies, use it first, then continue here if root cause is still unclear.
   - Preflight scan before questions: check README/docs/config/tests to find how to reproduce and how to run tests; cite file paths used.
1. Phase 1: Root cause investigation (no fixes).
   - Read errors/warnings completely (full stack trace, file/line, error codes).
   - Reproduce consistently or gather steps/data to do so.
   - Check recent changes (diffs, config, environment).
   - If multi-component, add minimal diagnostics at boundaries to identify where it breaks (inputs/outputs per layer).
   - Trace data flow back to the source of the bad value/state.
2. Phase 2: Pattern analysis.
   - Find working examples in the repo and compare line-by-line.
   - Identify all differences and dependencies (config, env, versions, assumptions).
3. Phase 3: Hypothesis and testing.
   - State a single hypothesis: "I think X because Y".
   - Make the smallest change to test it; one variable at a time.
   - If it fails, form a new hypothesis; do not stack fixes.
4. Phase 4: Implementation.
   - Create a failing test or minimal reproducible harness if feasible.
   - Implement a single fix for the root cause.
   - Re-run tests/verification and confirm the issue is resolved.
   - If 3 fixes fail, stop and discuss architecture before attempting more fixes.

## Diagnostics guidance (when needed)
- Prefer temporary, minimal instrumentation; remove it once the failing component is identified.
- For flaky or environment-dependent issues, capture environment details and timing data before changing code.

## Stack trace handling (when available)
- Parse the error input: exception type, message, inner exceptions, error codes, correlation IDs.
- Extract stack frames with file paths and line numbers.
- If logs are JSON, check common fields like `stackTrace`, `StackTrace`, `exception`, `message`, `detail`, `Failures`, `Warnings`, `traceId`.
- Map frames to repo files and prefer the first frame that points to in-repo source.
- Open the file at the reported line and read surrounding context; use `rg` to find related call sites.

## Hard stops
- No fixes before Phase 1 is complete.
- If the issue is not reproducible and lacks evidence, stop and ask for reproduction steps/logs.
- If stack traces lack file paths/line numbers, ask for symbols or a fuller trace.
- If required test/diagnostic commands are unclear from the repo, stop and ask.

## Response format
- If clarification is required, ask a single blocking question and stop.
- Otherwise respond concisely: goal recap, evidence collected, hypothesis (if any), next action.
- When a stack trace is provided, include a short triage summary: error type/message, primary file/line, suspected cause.

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Do not use multi-section outputs unless explicitly requested.
- Ask at most one blocking question and stop.
