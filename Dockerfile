FROM eclipse-temurin:21-alpine

ENV REVIEWDOG_VERSION=v0.21.0

# The immutable release tag pins both the installer and binary version.
RUN wget -q -O /tmp/install-reviewdog.sh \
      "https://raw.githubusercontent.com/reviewdog/reviewdog/${REVIEWDOG_VERSION}/install.sh" \
    && sh /tmp/install-reviewdog.sh -b /usr/local/bin/ "${REVIEWDOG_VERSION}" \
    && rm /tmp/install-reviewdog.sh
RUN apk add --no-cache git
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
