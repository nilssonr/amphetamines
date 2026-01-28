#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: worktree_setup.sh --type <feat|fix|chore> --topic <topic> [--base <base>] [--path <path>] [--branch <branch>]

Options:
  --type    Change type (feat|fix|chore)
  --topic   Short topic (used for branch and path)
  --base    Base branch or ref (default: detect origin/HEAD)
  --path    Worktree path (default: <repo>/.worktrees/<topic>)
  --branch  Branch name (default: <type>/<topic>)
USAGE
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

TYPE=""
TOPIC=""
BASE=""
PATH_ARG=""
BRANCH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="$2"; shift 2 ;;
    --topic) TOPIC="$2"; shift 2 ;;
    --base) BASE="$2"; shift 2 ;;
    --path) PATH_ARG="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ -z "$TYPE" || -z "$TOPIC" ]]; then
  echo "Missing --type or --topic" >&2
  usage
  exit 1
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not in a git repo" >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
GITIGNORE_PATH="${REPO_ROOT}/.gitignore"
if [[ ! -f "$GITIGNORE_PATH" ]]; then
  echo "Missing .gitignore at repo root; add .worktrees/ before proceeding." >&2
  exit 1
fi
if ! grep -Eq '^[[:space:]]*\.worktrees/?[[:space:]]*$' "$GITIGNORE_PATH"; then
  echo ".gitignore does not include .worktrees/; add it before proceeding." >&2
  exit 1
fi

TOPIC_SLUG="$(slugify "$TOPIC")"
if [[ -z "$BRANCH" ]]; then
  BRANCH="${TYPE}/${TOPIC_SLUG}"
fi

if [[ -z "$BASE" ]]; then
  BASE_REF="$(git symbolic-ref --quiet refs/remotes/origin/HEAD || true)"
  if [[ -z "$BASE_REF" ]]; then
    echo "Unable to detect base branch (origin/HEAD). Provide --base." >&2
    exit 1
  fi
  BASE="${BASE_REF#refs/remotes/origin/}"
fi

if [[ -z "$PATH_ARG" ]]; then
  PATH_ARG="${REPO_ROOT}/.worktrees/${TOPIC_SLUG}"
fi

if [[ -e "$PATH_ARG" ]]; then
  echo "Worktree path already exists: $PATH_ARG" >&2
  exit 1
fi

# Ensure parent directory exists inside repo
mkdir -p "${REPO_ROOT}/.worktrees"

# Fetch latest refs for base resolution
git fetch --all --prune

BASE_REF="$BASE"
if git show-ref --verify --quiet "refs/remotes/origin/${BASE}"; then
  BASE_REF="origin/${BASE}"
fi

git worktree add -b "$BRANCH" "$PATH_ARG" "$BASE_REF"

printf "Base branch: %s\nBranch: %s\nWorktree: %s\n" "$BASE" "$BRANCH" "$PATH_ARG"
