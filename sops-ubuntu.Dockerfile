FROM ubuntu:20.04

RUN apt update && apt install -y curl gnupg gettext-base make vim

RUN VERSION=3.6.1 PLATFORM=linux && \
    curl -Lo sops https://github.com/mozilla/sops/releases/download/v${VERSION}/sops-v${VERSION}.${PLATFORM} && \
    chmod +x sops && \
    mv sops /usr/local/bin/sops

WORKDIR /data