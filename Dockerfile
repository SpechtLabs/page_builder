FROM ubuntu:23.04

ARG HUGO_VERSION="0.118.2"
ARG NODE_MAJOR=20

WORKDIR /usr/local/src

# Install base software
RUN apt update
RUN apt install --yes git curl golang awscli ca-certificates gnupg --fix-missing

# Install Node.js and NPM
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Install base software
RUN apt update
RUN apt install --yes nodejs build-essential --fix-missing

RUN npm install autoprefixer postcss-cli tailwindcss --global

# Install HUGO
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

#COPY build-hugo.sh /home/builder/build-hugo.sh

ENTRYPOINT bash /home/builder/build-hugo.sh
