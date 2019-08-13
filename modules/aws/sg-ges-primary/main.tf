resource "aws_security_group" "ges-instance" {
  name        = "${var.name_tag_prefix}-ges-sg"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ingress-ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-SMTP" {
  type            = "ingress"
  from_port       = 25
  to_port         = 25
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-http" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-mgmtssh" {
  type            = "ingress"
  from_port       = 122
  to_port         = 122
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-replication" {
  type            = "ingress"
  from_port       = 1194
  to_port         = 1194
  protocol        = "udp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-git" {
  type            = "ingress"
  from_port       = 9418
  to_port         = 9418
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-mgmthttp" {
  type            = "ingress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "ingress-mgmthttps" {
  type            = "ingress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-ssh" {
  type            = "egress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-SMTP" {
  type            = "egress"
  from_port       = 25
  to_port         = 25
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-http" {
  type            = "egress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-mgmtssh" {
  type            = "egress"
  from_port       = 122
  to_port         = 122
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-https" {
  type            = "egress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-git" {
  type            = "egress"
  from_port       = 9418
  to_port         = 9418
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-mgmthttp" {
  type            = "egress"
  from_port       = 8080
  to_port         = 8080
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-mgmthttps" {
  type            = "egress"
  from_port       = 8443
  to_port         = 8443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.ges-instance.id}"
}

resource "aws_security_group_rule" "egress-icmp" {
  type = "egress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.ges-instance.id}"

}