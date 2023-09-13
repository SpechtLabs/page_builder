FROM ubuntu:23.04

ARG HUGO_VERSION="0.118.2"

RUN apt update
RUN apt install --yes git curl golang awscli --fix-missing

WORKDIR /usr/local/src

RUN arch=$(uname -m); echo $arch; if [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-arm64.tar.gz -o hugo_extended_${HUGO_VERSION}.tar.gz; else curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-64bit.tar.gz -o hugo_extended_${HUGO_VERSION}.tar.gz; fi;

RUN tar -xzf hugo_extended_${HUGO_VERSION}.tar.gz;
RUN cp /usr/local/src/hugo /usr/local/bin/hugo;

RUN useradd -ms /bin/bash builder

USER builder
WORKDIR /home/builder

# upload page to S3
ENV AWS_ACCESS_KEY_ID="<b2 app key id>"
ENV AWS_SECRET_ACCESS_KEY="<b2 app key>"
ENV S3_ENDPOINT="<s3 endpoint>"
ENV REPO_URL="<repo url>"
ENV GIT_BRANCH="main"
ENV S3_BUCKET_NAME="<bucket_name>"
ENV PAGE_NAME="<page name>"

ENTRYPOINT git clone --recurse-submodules -j8 --branch ${GIT_BRANCH} ${REPO_URL} $PAGE_NAME; \
    cd $PAGE_NAME;  \
    hugo;           \
    aws s3 cp public/ s3://${S3_BUCKET_NAME}/$PAGE_NAME --recursive --endpoint-url $S3_ENDPOINT
