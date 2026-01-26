#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  review_pr.sh <pr_url> [-- <command...>]

Creates a temporary workspace under /tmp, clones the PR base repo,
checks out the PR head, generates a diff against the base ref, and
cleans up on exit. If a command is provided, it runs in the repo root
with environment variables set:
  PR_REVIEW_DIR, PR_REVIEW_REPO, PR_REVIEW_DIFF, PR_REVIEW_DIFFSTAT

Examples:
  review_pr.sh https://github.com/org/repo/pull/123
  review_pr.sh https://github.com/org/repo/pull/123 -- bash -lc "rg -n 'TODO' . && sed -n '1,120p' path/file"
USAGE
}

if [[ ${1:-} == "" || ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 2
fi

pr_url="$1"
shift || true

if [[ ${1:-} == "--" ]]; then
  shift || true
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh is required" >&2
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "error: git is required" >&2
  exit 1
fi

review_dir="$(mktemp -d /tmp/gh-pr-review-XXXXXX)"
cleanup() {
  rm -rf "$review_dir"
}
trap cleanup EXIT

base_repo=$(gh pr view "$pr_url" --json baseRepository --jq '.baseRepository.nameWithOwner')
base_ref=$(gh pr view "$pr_url" --json baseRefName --jq '.baseRefName')

repo_dir="$review_dir/repo"

gh repo clone "$base_repo" "$repo_dir" >/dev/null

cd "$repo_dir"

# Checkout the PR head (handles forks and remotes via gh)
gh pr checkout "$pr_url" >/dev/null

git fetch origin "$base_ref" >/dev/null

git diff "origin/$base_ref"...HEAD > "$review_dir/pr.diff"
git --no-pager diff --stat "origin/$base_ref"...HEAD > "$review_dir/pr.diffstat" || true

export PR_REVIEW_DIR="$review_dir"
export PR_REVIEW_REPO="$repo_dir"
export PR_REVIEW_DIFF="$review_dir/pr.diff"
export PR_REVIEW_DIFFSTAT="$review_dir/pr.diffstat"

cat <<INFO
Workspace: $PR_REVIEW_DIR
Repo:      $PR_REVIEW_REPO
Diff:      $PR_REVIEW_DIFF
Diffstat:  $PR_REVIEW_DIFFSTAT
INFO

if [[ $# -gt 0 ]]; then
  "$@"
else
  cat "$PR_REVIEW_DIFFSTAT"
fi
