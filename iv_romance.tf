variable "name" {
  default = "iv-romance"
}

variable "environment_tag" {
  default = "production"
}

locals {
  aws_bucket_name = "${var.name}-uploads-${var.environment_tag}"
  aws_user_name   = "${var.name}-uploads-${var.environment_tag}"
}

resource "heroku_app" "iv_romance" {
  name         = "${var.name}"
  region       = "${var.heroku_region}"
  stack        = "${var.heroku_stack}"

  buildpacks = [
    "https://github.com/HashNuke/heroku-buildpack-elixir.git",
    "https://github.com/gjaldon/heroku-buildpack-phoenix-static.git"
  ]
}

resource "heroku_addon" "iv_romance_database" {
  app  = "${heroku_app.iv_romance.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "aws_s3_bucket" "uploads" {
  bucket = "${local.aws_bucket_name}"
  acl    = "public-read"

  tags {
    Name        = "${local.aws_bucket_name}"
    Environment = "${var.environment_tag}"
  }
}

resource "aws_s3_bucket_policy" "uploads" {
  bucket = "${aws_s3_bucket.uploads.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.uploads.arn}/*"]
    }
  ]
}
POLICY
}

resource "aws_iam_user" "uploads" {
  name = "${local.aws_user_name}"
}

resource "aws_iam_user_policy" "uploads" {
  user = "${aws_iam_user.uploads.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.uploads.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_access_key" "uploads" {
  user = "${aws_iam_user.uploads.name}"
}

output "uploads_bucket_name" {
  value = "${aws_s3_bucket.uploads.id}"
}

output "uploads_access_key_id" {
  value = "${aws_iam_access_key.uploads.id}"
}

output "uploads_access_key_secret" {
  value = "${aws_iam_access_key.uploads.secret}"
}
