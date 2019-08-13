# S3 Bucket for license file storage
resource "aws_s3_bucket" "ges-license-bucket" {
  bucket        = "ges-license-bucket"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "${var.name_tag_prefix}-ges-license"
  }
}

resource "aws_s3_bucket_object" "ges-license" {
  bucket = "${aws_s3_bucket.ges-license-bucket.id}"
  key    = "/license/ges-license.ghl"
  source = "${var.ges_license_path}"
}

resource "aws_s3_bucket_object" "ges-provisioning-script" {
  bucket = "${aws_s3_bucket.ges-license-bucket.id}"
  key    = "/scripts/ges-provisioning-script.sh"
  source = "${var.ges_provisioning_script}"
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  description = "This policy gives full admin rights to interact with S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "S3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.ges-license-bucket.id}"

  policy = <<POLICY
{
    "Id": "test",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1442576554133",
            "Action": "s3:GetObject",
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::ges-license-bucket",
                "arn:aws:s3:::ges-license-bucket/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpc": "${var.vpc_id}"
                }
            },
            "Principal": "*"
        }
    ]
}
POLICY
}