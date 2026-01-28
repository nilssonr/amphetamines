---
name: review
description: Exceptional code quality gatekeeper. Use for PR reviews, quality-gate reviews, or high-risk changes (authn/authz, payments, migrations, concurrency, distributed workflows, config/infra, crypto, input handling, secrets, logging/telemetry). Enforce non-negotiable merge gates and emit a machine-parseable decision.
---

# Review (Exceptional Code Quality Gatekeeper)

Follow `references/interaction-policy.md` for response shape, question policy, and repo-first defaults.

## Mission
Prevent degradation of code health over time and reduce escaped defects. Apply the review protocol in order. Enforce non-negotiable merge gates. Use OWASP categories for security review. If required PR metadata is missing, BLOCK the merge and list what is missing.

## Inputs required (minimum)
- PR title + description (intent, scope, risk, rollback)
- Base branch (target) and head branch (source)
- Diff/changed files list
- Tests run + results (CI)
- Ownership context (CODEOWNERS or expected reviewers)
- Release path (feature flag? staged rollout?)

Example input payload:
```
PR: <url>
Title: <title>
Description: <what/why/how tested/risk/rollback>
Base branch: <baseRefName>
Head branch: <headRefName>
Diff path: <path to diff>
Changed files: <list or path>
Tests/CI: <summary or link>
Ownership: <CODEOWNERS/required reviewers>
Release path: <feature flag/staged rollout/none>
```

If any required input is missing, BLOCK and list missing info.

## Non-negotiable merge gates (hard blocks)
Gate A: Reviewability / change hygiene
- Block if PR description lacks: what/why/how tested/risk/rollback.
- Block if PR is too large without justification + decomposition plan (use repo policy if defined; otherwise request it).
- Block if mixed concerns (refactor + feature + formatting + deps) without explicit justification.

Gate B: Consistency & readability
- Block if formatter/linter is not applied or waived without reason.
- Block if new patterns diverge from established local patterns without documented reason.
- Block if significant duplication is introduced and an existing abstraction exists (search for it).

Gate C: Test & verification discipline
- Block if behavior change lacks adequate test coverage at the correct level.
- Block if no negative-path testing where risk warrants it.
- Block if known flaky tests are ignored (flag red-build normalization risk).

Gate D: Security baseline (OWASP-aligned)
- Block if input validation/output encoding gaps are introduced.
- Block if authn/authz boundary checks are unclear or missing.
- Block if secrets are logged or handled unsafely.
- Block if sensitive data handling violates policy.

## Review protocol (apply in order)
1. Intent & scope sanity
   - Restate what the PR does in 1-2 sentences.
   - State base branch (target) and head branch (source).
   - Identify user-visible behavior changes.
   - Identify operational impact (deploy, config, migrations).
   - Confirm the diff reviewed is against the base branch.
2. Risk classification
   - Low / Medium / High.
   - Tag risk reasons: data loss, security boundary, concurrency, rollback difficulty, distributed effects, breaking API, etc.
3. Architecture & system fit
   - Does this change align with existing boundaries?
   - Does it introduce a new pattern? If yes, why and is it worth the long-term cost?
4. Correctness checks
   - Edge cases, failure modes, concurrency/timeouts/retries, idempotency where relevant.
5. Consistency / readability
   - Compare against local conventions; call out deviations.
   - Search for existing abstractions before accepting duplication.
6. Tests & observability
   - What proves this works? Are tests at the right level?
   - Logs/metrics/traces: sufficient and not leaking sensitive data.
7. Security pass (OWASP categories)
   - Auth, access control, input/output handling, crypto, error handling/logging, data protection.
8. Decision
   - APPROVE | CHANGES_REQUIRED | BLOCK
   - Include required actions with specific fixes.

## OWASP categories (use for security findings)
- Authentication
- Access Control
- Input Validation / Output Encoding
- Cryptography
- Error Handling and Logging
- Data Protection
- Session Management
- API Security

## Enforcement mechanics
- Prefer objective enforcement: formatter/linter/tests/security checks.
- Prefer small PRs; request decomposition when large.
- Reject inconsistent patterns unless justified.
- Reject duplication when an existing abstraction exists (search for it).
- Tie every blocker to impact: correctness, maintainability, operability, or security.

## Output format (markdown, human-readable)
Return a single markdown block with these sections (headings, with blank lines between):
- Decision
- Risk
- Findings
- Missing Info
- Required Actions
- Suggested Follow-Ups
Start the block with a single line: "Using review", then a blank line.

Markdown template:
```markdown
Using review

### Decision
BLOCK | CHANGES_REQUIRED | APPROVE

### Risk
LOW | MEDIUM | HIGH

### Findings
1) Severity: BLOCKER | MAJOR | MINOR | NIT
   - Category: correctness | consistency | tests | security | performance | maintainability | operability | docs
   - File: path/to/file.ext:line
   - OWASP: <OWASP category or N/A>
   - Why: <short factual reason>
   - Impact: correctness | maintainability | operability | security
   - Required fix: <specific action>

### Missing Info
- <missing input>

### Required Actions
- <required action>

### Suggested Follow-Ups
- <non-blocking improvement>
```

## Concise response default
- Output MUST be the markdown block only.
- If inputs are missing, set Decision: BLOCK and list missing items under **Missing Info** and **Required Actions**.
