#!/bin/sh

echo "Running check(andy)"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

exec cat /sample.xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"
