# PR Review Checklist

## Contents
- Scope and metadata
- Correctness and bugs
- Security and privacy
- Performance and scalability
- Consistency and maintainability
- Tests and verification
- Docs and operability

## Scope and metadata
- Confirm base branch and head branch are correct for the diff.
- Confirm the PR title/description matches the change.
- Identify risky areas: auth, money, data loss, migrations, concurrency, infra.

## Correctness and bugs
- Validate inputs, outputs, and error handling paths.
- Check null/empty cases, boundary conditions, off-by-one issues.
- Verify state transitions and invariants.
- Look for unintended behavior changes in shared utilities.

## Security and privacy
- Check authorization and authentication coverage.
- Look for data exposure in logs, errors, or responses.
- Validate sanitization for external inputs.
- Evaluate secret handling and configuration changes.

## Performance and scalability
- Identify new loops, queries, or N+1 patterns.
- Verify caching or batching when needed.
- Check hot paths for unnecessary allocations or work.

## Consistency and maintainability
- Match existing architecture, naming, and conventions.
- Avoid duplicate logic if similar code exists.
- Ensure config, feature flags, or toggles follow existing patterns.
- If `.editorconfig` exists, verify adherence (formatting, indentation, line endings).

## Tests and verification
- Confirm tests cover new behavior and edge cases.
- Identify missing tests for regressions or critical paths.
- Suggest targeted tests where appropriate.

## Docs and operability
- Update README or docs for API/behavior changes.
- Verify migrations, runbooks, or config notes if needed.
- Check logging/metrics additions for operability.
