#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: worktree_cleanup.sh --path <path> --branch <branch> --outcome <merged|discarded>
USAGE
}

PATH_ARG=""
BRANCH=""
OUTCOME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) PATH_ARG="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --outcome) OUTCOME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$PATH_ARG" || -z "$BRANCH" || -z "$OUTCOME" ]]; then
  echo "Missing required args" >&2
  usage
  exit 1
fi

if [[ "$OUTCOME" != "merged" && "$OUTCOME" != "discarded" ]]; then
  echo "Outcome must be merged or discarded" >&2
  exit 1
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not in a git repo" >&2
  exit 1
fi

git worktree remove "$PATH_ARG"

if [[ "$OUTCOME" == "merged" ]]; then
  git branch -d "$BRANCH"
else
  git branch -D "$BRANCH"
fi

printf "Removed worktree: %s\nDeleted branch: %s\n" "$PATH_ARG" "$BRANCH"
