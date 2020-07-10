#!/bin/sh

echo "Running check(andy5)"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
echo "git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} ${GITHUB_BASE_REF}"
exec git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} origin/${GITHUB_BASE_REF} > changes.txt
echo "changes.txt generated"
