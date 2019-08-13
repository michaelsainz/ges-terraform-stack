output "license-url" {
    value = "https://${aws_s3_bucket.ges-license-bucket.bucket_domain_name}/license/ges-license.ghl"
}