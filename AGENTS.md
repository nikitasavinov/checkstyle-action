# AGENTS.md

## Cursor Cloud specific instructions

### What this repo is

This repository is a **Docker-based GitHub Action** (`checkstyle-action`) that runs
[Checkstyle](https://github.com/checkstyle/checkstyle) on Java code and reports results via
[reviewdog](https://github.com/reviewdog/reviewdog). See `README.md`, `action.yml`, `Dockerfile`,
and `entrypoint.sh`.

There is **no package manager, no test suite, no linter, and no dev server**. The only "build" is
`docker build`, and the only way to "run" the product is to execute the container the way GitHub
Actions would.

### Docker daemon (required, not auto-started)

Everything here needs Docker. The Docker engine is provisioned in the VM, but the daemon is **not**
started automatically on boot. Start it once per session (needs sudo) before building/running:

```bash
sudo dockerd > /tmp/dockerd.log 2>&1 &
# wait a few seconds, then verify:
sudo docker info
```

Docker is configured (`/etc/docker/daemon.json`) with the `fuse-overlayfs` storage driver and
`containerd-snapshotter` disabled — both are required for Docker to work in this VM (the kernel
lacks full overlay2 support, and the containerd snapshotter is incompatible with fuse-overlayfs on
Docker 29+). Do not remove that config.

### Build

```bash
docker build . --file Dockerfile --tag checkstyle-action:local
```

> Egress caveat: the `Dockerfile` fetches from `github.com` / `raw.githubusercontent.com`
> (reviewdog + the Checkstyle JAR) and `dl-cdn.alpinelinux.org` (`apk add --no-cache git`). All
> three are on the network allowlist for this environment. If a fresh VM ever blocks
> `dl-cdn.alpinelinux.org` again, the build fails at the `apk add git` step with a
> TLS/connection-reset error — re-request that domain in the network allowlist to unblock it.

### Run the action locally (no PR / no GitHub token needed)

The action is normally driven by GitHub Actions env vars. To run it against any Java project locally,
use reviewdog's `local` reporter with `nofilter` (there's no PR diff to filter against):

```bash
docker run --rm \
  -e GITHUB_WORKSPACE=/github/workspace \
  -e INPUT_CHECKSTYLE_CONFIG=google_checks.xml \
  -e INPUT_CHECKSTYLE_VERSION=10.3 \
  -e INPUT_WORKDIR=. \
  -e INPUT_LEVEL=info \
  -e INPUT_TOOL_NAME=checkstyle \
  -e INPUT_REPORTER=local \
  -e INPUT_FILTER_MODE=nofilter \
  -e INPUT_FAIL_ON_ERROR=false \
  -v "$(pwd)/your-java-project:/github/workspace" \
  checkstyle-action:local
```

`google_checks.xml` and `sun_checks.xml` are bundled inside the Checkstyle JAR, so they resolve by
name without a local file. Real CI usage instead sets `INPUT_GITHUB_TOKEN` and
`INPUT_REPORTER=github-pr-check`/`github-pr-review` to post inline PR comments.
