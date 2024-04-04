#!/usr/bin/env bash

set -ex

git clone --recurse-submodules -j8 --branch "$GIT_BRANCH" "$REPO_URL" "$PAGE_NAME"
cd "$PAGE_NAME"
hugo
aws s3 cp public/ "s3://$S3_BUCKET_NAME/$PAGE_NAME" --recursive --endpoint-url "$S3_ENDPOINT" --cli-connect-timeout 6000
