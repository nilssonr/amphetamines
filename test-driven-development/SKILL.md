---
name: test-driven-development
description: Enforce test-first workflow (red-green-refactor) for features, bug fixes, refactors, and behavior changes. Use when asked about TDD or when defining TDD expectations.
---

# Test-Driven Development

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using test-driven-development" followed by a blank line.

1. Confirm scope and how tests are run (repo command, script, or standard tool).
2. Apply the TDD loop and enforce the gates below.
3. If a TDD exception applies, require a deterministic verification step instead.

## When to Use
- New features
- Bug fixes
- Refactors
- Behavior changes
- When a user asks about TDD policy or expectations

## TDD Exceptions (skip TDD only when applicable)
Skip TDD only for:
- Configuration-only changes
- Infrastructure-only changes (e.g., Kubernetes manifests)
- Documentation-only changes
- Simple script-only changes where tests are disproportionate, defined as:
  - Single-file script change
  - Small surface area (roughly <= 50 lines changed)
  - No branching business logic or data model
  - No external integrations beyond shell commands or file I/O

If an exception applies, require the best available verification step (lint, schema validation, dry-run, or a deterministic invocation). If no verification is defined in the repo, stop and ask for the preferred command.

## The Iron Law
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```
If implementation code exists before its test, delete it and restart with a failing test.

## Red-Green-Refactor Loop
- RED: Write one minimal test for one behavior. Use real behavior, not mock-only assertions.
- VERIFY RED: Run tests and confirm the failure is expected and tied to missing behavior.
- GREEN: Write the smallest change to pass.
- VERIFY GREEN: Re-run tests; all relevant tests must pass.
- REFACTOR: Clean up only after green; keep tests passing.

## Quality Gates
- One behavior per test with a clear name.
- Tests must assert real behavior (avoid testing mocks).
- No test-only methods in production code.
- If mocking is required, understand side effects first; prefer integration tests when mocks grow complex.

## Red Flags (stop and fix)
- Test passes immediately.
- Test added after implementation.
- Failure is unrelated to the new behavior.
- Assertions only prove mock behavior.

## Verification Checklist
- [ ] Test written first and observed failing for the right reason.
- [ ] Minimal implementation added to pass.
- [ ] Tests re-run and passing.
- [ ] Any refactor kept tests green.

## Examples

### Feature (TDD)
1. RED: Add a test for retrying a transient failure and run it to see the expected failure.
2. GREEN: Implement the smallest retry loop that passes the test.
3. REFACTOR: Extract helpers if needed, keeping tests green.

### Exception (simple script-only change)
- Change: Add a small flag to a single bash script (single file, ~20 lines touched).
- Verification: `shellcheck path/to/script.sh` and a deterministic invocation, e.g. `./script.sh --help`.

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Ask at most one blocking question and stop.
