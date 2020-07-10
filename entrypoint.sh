#!/bin/sh

echo "Running check(andy2)"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

exec git config --global --add remote.origin.fetch "+refs/pull/*/head:refs/remotes/origin/pr/*"
exec env
exec git diff-tree --no-commit-id --name-only -r ${GITHUB_REF} ${GITHUB_SHA} >changes.txt
exec cat changes.txt
exec cat /sample.xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"
