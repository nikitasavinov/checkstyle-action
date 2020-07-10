#!/bin/sh

echo "Running check(andy3)"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
env
echo "git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} origin/${GITHUB_BASE_REF}"
git config --global --add remote.origin.fetch "+refs/pull/*/head:refs/remotes/origin/pr/*"
git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} origin/${GITHUB_BASE_REF} > changes.txt
cat changes.txt
exec cat /sample.xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"
