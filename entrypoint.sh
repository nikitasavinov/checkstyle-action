#!/bin/sh

echo "Running check"

cd "${GITHUB_WORKSPACE}" || exit 1

git config --global --add safe.directory $GITHUB_WORKSPACE

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

wget -O - -q https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${INPUT_CHECKSTYLE_VERSION}/checkstyle-${INPUT_CHECKSTYLE_VERSION}-all.jar > /checkstyle.jar

report="$(mktemp)"
trap 'rm -f "${report}"' EXIT

set +e
if [ -n "${INPUT_PROPERTIES_FILE}" ]; then
  java -jar /checkstyle.jar "${INPUT_WORKDIR}" -c "${INPUT_CHECKSTYLE_CONFIG}" \
    -p "${INPUT_PROPERTIES_FILE}" -f xml >"${report}" 2>/tmp/checkstyle.err
else
  java -jar /checkstyle.jar "${INPUT_WORKDIR}" -c "${INPUT_CHECKSTYLE_CONFIG}" \
    -f xml >"${report}" 2>/tmp/checkstyle.err
fi
checkstyle_status=$?
set -e

if [ -s /tmp/checkstyle.err ]; then
  cat /tmp/checkstyle.err >&2
fi

# Checkstyle exits non-zero for both violations and hard failures. Only treat it as a
# hard failure when it produced no XML report for reviewdog to consume.
if [ "${checkstyle_status}" -ne 0 ] && [ ! -s "${report}" ]; then
  exit "${checkstyle_status}"
fi

reviewdog -f=checkstyle \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE:-added}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
      -level="${INPUT_LEVEL}" \
      <"${report}"
