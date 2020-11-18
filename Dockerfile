FROM openjdk:8-alpine

ENV REVIEWDOG_VERSION=v0.10.0
ENV INPUT_CHECKSTYLE_VERSION=8.37

RUN wget -O - -q https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${INPUT_CHECKSTYLE_VERSION}/checkstyle-${INPUT_CHECKSTYLE_VERSION}-all.jar > /checkstyle.jar
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN apk add --no-cache git
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
