# Page Builder

This Docker Container contains the AWS-CLI and Hugo to build the hugo static page and uploads it to S3 using the aws-cli

## Env Vars

Configure the Container using the environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `S3_ENDPOINT`
* `REPO_URL`
* `S3_BUCKET_NAME`
* `PAGE_NAME`