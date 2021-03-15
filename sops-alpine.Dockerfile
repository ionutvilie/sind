FROM alpine:latest

RUN apk --no-cache add bash curl gnupg make vim

RUN VERSION=3.6.1 PLATFORM=linux && \
    curl -Lo sops https://github.com/mozilla/sops/releases/download/v${VERSION}/sops-v${VERSION}.${PLATFORM} && \
    chmod +x sops && \
    mv sops /usr/local/bin/sops

WORKDIR /data