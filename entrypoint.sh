#!/bin/sh

echo "Running check"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

git fetch origin ${GITHUB_BASE_REF}
git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} origin/${GITHUB_BASE_REF} > changes.txt
echo "changes.txt generated"
node /java-checkstyle/src/checkstyle /github/workspace
echo "checkstyle-result.xml generated"
cat /github/workspace/checkstyle-result.xml
exec cat /github/workspace/checkstyle-result.xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"
