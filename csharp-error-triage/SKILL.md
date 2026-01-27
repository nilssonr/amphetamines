---
name: csharp-error-triage
description: Systematic triage for C# errors from logs, exceptions, or stack traces. Use when the user provides an error line, exception message, or stack trace and either a C# stack trace is detected or the repo is C# (.csproj/.sln/Directory.Build.props/*.cs).
---

# C# Error Triage

## Inputs
- Error input from the user: log line, stack trace, exception message, or structured log entry (JSON or text).

## Detection
- Confirm C# context by either signal:
  - Stack trace includes patterns like `at Namespace.Type.Method(...)` and `in <path>.cs:line <n>`.
  - Repo contains C# indicators: `*.csproj`, `*.sln`, `Directory.Build.props`, `Directory.Build.targets`, or `*.cs`.
  - Use `references/csharp-signals.md` for a quick checklist and search commands.

## Workflow
1. Parse the error input.
   - Extract exception type, message, inner exceptions, error codes, and any correlation ids.
   - Extract stack trace frames with file paths and line numbers.
   - If JSON, look for `stackTrace`, `StackTrace`, `exception`, `message`, `detail`, `Failures`, `Warnings`, and `traceId`.
   - For large or messy inputs, use `scripts/parse_csharp_trace.py` to extract frames and exception summaries (including `innerException`).
2. Map stack frames to repo files.
   - Prefer the first frame in repo source (has `.cs` path and line).
   - Normalize absolute paths (e.g., `/src/...`) to repo-relative paths.
3. Gather code context.
   - Open the file at the reported line and read enough surrounding context to understand inputs and branching.
   - Use `rg` to find the symbol or method and related call sites.
4. Identify the likely root cause.
   - Distinguish external dependency failures vs. local logic errors.
   - Check for common C# failure modes: null deref, invalid state, missing config, bad parsing, async timing, and API contract changes.
   - If only an error code is available, search for code that emits or handles that code.
5. Propose a minimal fix.
   - Suggest the smallest safe change that addresses the root cause.
   - If the fix is uncertain, offer two small alternatives and explain the tradeoff.
6. Offer next actions.
   - Present a choice to apply the fix, continue deeper triage, or add targeted logging/guards.

## Output format
- Start with a short triage summary: error type/message, primary file/line, and suspected cause.
- Provide evidence: cite the stack frame and the code location you inspected.
- Provide a suggested fix as a small code snippet and file path.
- End with explicit choices, numbered:
  1) Apply the fix (edit file now).
  2) Continue deeper trace (expand search to callers/configs).
  3) Add logging/guards (minimal instrumentation).

## Guardrails
- If no C# signal is present, stop and ask for confirmation or more context.
- If stack trace lacks file paths, ask for build symbols or a fuller trace.
- Do not assume frameworks or libraries unless repo evidence shows them.
