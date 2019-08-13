resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "${var.name_tag_prefix}-ges-vpc"
  }
}

resource "aws_internet_gateway" "primary" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.name_tag_prefix}-ges-igw"
  }
}

data "aws_prefix_list" "private-s3" {
  prefix_list_id = "${aws_vpc_endpoint.private-s3.prefix_list_id}"
}

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${aws_vpc.main.id}"
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${aws_vpc.main.default_route_table_id}"]

  policy = <<POLICY
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_route" "internet" {
  route_table_id            = "${aws_vpc.main.default_route_table_id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.primary.id}"
}