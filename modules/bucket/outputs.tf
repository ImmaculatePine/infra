output "bucket_name" {
  value = "${aws_s3_bucket.default.id}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.default.id}"
}

output "access_key_secret" {
  value = "${aws_iam_access_key.default.secret}"
}
