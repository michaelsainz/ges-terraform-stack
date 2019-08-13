data "aws_availability_zones" "aws_az" {
    state = "available"
}

resource "aws_subnet" "primary" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.cidr_block}"
  availability_zone       = "${data.aws_availability_zones.aws_az.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name_tag_prefix}-ges-subnet"
  }
}