#!/bin/sh

echo "Running check"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

exec java -jar /checkstyle.jar -c /"${INPUT_CHECKSTYLE_CONFIG}" ./ -f xml \
 | reviewdog -f=checkstyle -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"

