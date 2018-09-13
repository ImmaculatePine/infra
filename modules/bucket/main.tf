locals {
  aws_bucket_name = "${var.resource_name}-${var.environment}"
  aws_user_name   = "${var.resource_name}-${var.environment}"
}

resource "aws_s3_bucket" "default" {
  bucket = "${local.aws_bucket_name}"
  acl    = "public-read"

  tags {
    Name        = "${local.aws_bucket_name}"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.default.arn}/*"]
    }
  ]
}
POLICY
}

resource "aws_iam_user" "default" {
  name = "${local.aws_user_name}"
}

resource "aws_iam_user_policy" "default" {
  user = "${aws_iam_user.default.name}"

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
      "Resource": "${aws_s3_bucket.default.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_access_key" "default" {
  user = "${aws_iam_user.default.name}"
}
