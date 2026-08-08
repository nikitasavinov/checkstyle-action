#!/bin/sh

echo "Running check"

cd "${GITHUB_WORKSPACE}" || exit 1

git config --global --add safe.directory "${GITHUB_WORKSPACE}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

case "${INPUT_FAIL_LEVEL}" in
  ''|none|any|info|warning|error) ;;
  *)
    echo "Invalid fail_level: '${INPUT_FAIL_LEVEL}'. Expected one of: none, any, info, warning, error." >&2
    exit 1
    ;;
esac

checkstyle_version="${INPUT_CHECKSTYLE_VERSION}"
checkstyle_jar="/checkstyle.jar"
checkstyle_url="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${checkstyle_version}/checkstyle-${checkstyle_version}-all.jar"

if ! wget -q -O "${checkstyle_jar}" "${checkstyle_url}"; then
  echo "Failed to download Checkstyle ${checkstyle_version} from ${checkstyle_url}" >&2
  exit 1
fi
if [ ! -s "${checkstyle_jar}" ]; then
  echo "Downloaded Checkstyle jar is empty: ${checkstyle_url}" >&2
  exit 1
fi
if ! java -jar "${checkstyle_jar}" --version >/dev/null 2>&1; then
  echo "Downloaded Checkstyle jar is not usable (bad download or unsupported version): ${checkstyle_url}" >&2
  exit 1
fi

report="$(mktemp)"
trap 'rm -f "${report}"' EXIT

set +e
if [ -n "${INPUT_PROPERTIES_FILE}" ]; then
  java -jar "${checkstyle_jar}" "${INPUT_WORKDIR}" -c "${INPUT_CHECKSTYLE_CONFIG}" \
    -p "${INPUT_PROPERTIES_FILE}" -f xml >"${report}" 2>/tmp/checkstyle.err
else
  java -jar "${checkstyle_jar}" "${INPUT_WORKDIR}" -c "${INPUT_CHECKSTYLE_CONFIG}" \
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

# Leave -fail-level unset when the input is empty so reviewdog keeps FailLevelDefault.
# That lets its deprecated -fail-on-error shim apply the reporter-specific mapping
# (github-[pr-]check -> error, other reporters -> any). Passing -fail-level=none would
# suppress that shim.
fail_level_display="${INPUT_FAIL_LEVEL:-default}"
reporter="${INPUT_REPORTER:-github-pr-check}"
echo "reviewdog_failure_policy reporter=${reporter} fail_level=${fail_level_display} fail_on_error=${INPUT_FAIL_ON_ERROR:-false}" >&2

set -- reviewdog -f=checkstyle \
  -name="${INPUT_TOOL_NAME}" \
  -reporter="${reporter}" \
  -filter-mode="${INPUT_FILTER_MODE:-added}" \
  -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
  -level="${INPUT_LEVEL}"

if [ -n "${INPUT_FAIL_LEVEL}" ]; then
  set -- "$@" -fail-level="${INPUT_FAIL_LEVEL}"
fi

"$@" <"${report}"
