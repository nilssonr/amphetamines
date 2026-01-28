#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: init_plan.sh --title "Feature Name" [--dir docs/plans]
USAGE
}

TITLE=""
DIR="docs/plans"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="$2"; shift 2 ;;
    --dir) DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$TITLE" ]]; then
  echo "Missing --title" >&2
  usage
  exit 1
fi

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

DATE_STR="$(date +%F)"
SLUG="$(slugify "$TITLE")"
FILE="${DIR}/${DATE_STR}-${SLUG}.md"

mkdir -p "$DIR"

cat <<EOF > "$FILE"
# ${TITLE}

**Goal:** <One sentence describing what this builds>
**Architecture:** <2-3 sentences about approach>
**Tech Stack:** <Key technologies/libraries>
**Execution:** Use the execute-plan skill in this session

## Context
<Brief summary of the brainstormed idea and decisions.>

## Goals
- <Goal 1>

## Non-goals
- <Non-goal 1>

## Assumptions & Constraints
- <Assumption or constraint>

## Step-by-step Plan
1. <Task name>
   - Step 1: Write the failing test (files: <path>)
   - Step 2: Run tests (expect fail)
     - Command: `<exact command>`
     - Expected: <exact failure output>
   - Step 3: Write the minimal implementation (files: <path>)
   - Step 4: Run tests (expect pass)
     - Command: `<exact command>`
     - Expected: <exact pass output>
   - Step 5: Commit
     - Commands: `git add <paths>`; `git commit -m "<type>: <summary>"`

## Implementation Details (by file)

### <path/to/file.ext>
```diff
@@
-<old>
+<new>
```

## Testing & Verification
- <Command or manual check>

## Risks / Open Questions
- <Risk or question>

## Acceptance Checklist
- [ ] <Criterion>

## Execution Handoff
Ready to proceed with execute-plan in this session?
EOF

printf "Plan created: %s\n" "$FILE"
