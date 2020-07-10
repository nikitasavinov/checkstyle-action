#!/bin/sh

echo "Running check(andy7)"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# exec git fetch origin ${GITHUB_BASE_REF}
# exec git diff-tree -r --no-commit-id --name-only ${GITHUB_SHA} origin/${GITHUB_BASE_REF} > changes.txt
echo "changes.txt generated"

# exec git clone https://github.com/andxu/java-checkstyle ../java-checkstyle
# exec cd ../java-checkstyle && git checkout develop && npm i && node src/checkstyle /github/workspace
exec echo 'src/main/java/com/example/App.java' > changes.txt
exec node /java-checkstyle/src/checkstyle /github/workspace
# exec cat /github/workspace/checkstyle-result.xml \
# exec cat /sample.xml \
#  | reviewdog -f=checkstyle \
#       -name="${INPUT_TOOL_NAME}" \
#       -reporter="${INPUT_REPORTER:-github-pr-check}" \
#       -filter-mode="${INPUT_FILTER_MODE:-added}" \
#       -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
#       -level="${INPUT_LEVEL}"



exec cat /sample.xml \
 | reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}"