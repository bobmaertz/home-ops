FROM ghcr.io/actions/actions-runner:latest

# Use Chainguard's hardened, minimal Kaniko image as the executor source.
# Chainguard images are distroless and rebuilt nightly with zero known CVEs.
COPY --from=cgr.dev/chainguard/kaniko /kaniko/executor /kaniko/executor
COPY --from=cgr.dev/chainguard/kaniko /kaniko/ssl /kaniko/ssl

# Kaniko writes credentials and temp files here at build time.
RUN mkdir -p /kaniko/.docker

# Kaniko executor must run as root to unpack and snapshot filesystem layers.
# This does NOT require privileged: true — root-in-container only.
USER root
