---
name: testing-anti-patterns
description: Use when writing or changing tests, adding mocks, or considering test-only methods in production code. Prevents testing mock behavior, production pollution with test-only methods, and mocking without understanding dependencies.
---

# Testing Anti-Patterns

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Workflow
Start every response with: "Using testing-anti-patterns".

0. Apply the iron laws before proceeding.
   - Never test mock behavior.
   - Never add test-only methods to production classes.
   - Never mock without understanding dependencies and side effects.

1. Check for common violations.
   - Assertions that only confirm mock presence.
   - Production methods only used by tests.
   - Mocks that replace methods with critical side effects.
   - Partial mocks that omit fields used downstream.
   - Tests added after implementation with no red-green confirmation.

2. Enforce gates.
   - If an assertion targets a mock or test-only element, require a real-behavior assertion or unmock.
   - If a method exists only for tests, move it to test utilities.
   - If mock side effects are unknown, require running with the real implementation first.
   - If mock data is partial, require full schema parity with real responses.

3. Provide corrective guidance.
   - Recommend minimal, realistic mocks at the correct level.
   - Prefer integration tests when mocks become complex.
   - Require TDD red-green evidence for new behaviors.

## Red flags
- Assertions on `*-mock` test IDs or mock-only DOM.
- Test-only methods on production classes.
- Mock setup longer than test logic.
- Mocks added "to be safe" or without dependency understanding.
- Partial mock objects missing documented fields.

## Hard stops
- If a test only proves mock behavior, stop and require a real behavior assertion.
- If a test-only method is proposed in production code, stop and require a test utility instead.
- If mocking is proposed without understanding dependencies, stop and require investigation first.

## Concise response default
- Default to 1-4 bullets or 2-5 short sentences.
- Ask at most one blocking question and stop.
