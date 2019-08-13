provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_security_group" "bastion-host-security-group" {
  description = "Enable SSH access to the bastion host from external via SSH port"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "122"
    to_port     = "122"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "122"
    to_port     = "122"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name_tag_prefix}-ges-bastion-sg"
  }
}

resource "aws_iam_role" "bastion-host-role" {
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bastion_host_role_policy" {
  role = "${aws_iam_role.bastion_host_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": "arn:aws:s3:::${var.bastion_log_s3_bucket}/logs/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bastion_log_s3_bucket}/public-keys/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${var.bastion_log_s3_bucket}",
      "Condition": {
        "StringEquals": {
          "s3:prefix": "public-keys/"
        }
      }
    }
  ]
}
EOF
}

resource "aws_lb_target_group" "bastion_lb_target_group" {
  name     = "${var.name_tag_prefix}-ges-lb-tg8443"
  port        = "122"
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }

  tags {
    Name = "${var.name_tag_prefix}-ges-bastion-lb-tg"
  }
}

resource "aws_lb_listener" "bastion-lb-listener-122" {
  load_balancer_arn = "${var.lb_arn}"
  port              = "122"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.bastion_lb_target_group.arn}"
  }
}

resource "aws_iam_instance_profile" "bastion-host-profile" {
  role = "${aws_iam_role.bastion-host-role.name}"
  path = "/"
}

resource "aws_instance" "ges-ec2" {
  ami                  = "${data.aws_ami.ghe-instance.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ec2_key_name}"
  user_data = "${var.user_data}"

  network_interface {
    device_index          = 0
    network_interface_id  = "${aws_network_interface.ges-network-adapter.id}"
  }

  ebs_block_device = {
    delete_on_termination = true
    device_name           = "/dev/sda2"
    iops                  = 4000
    volume_size           = 1024
    volume_type           = "gp2"
  }

  tags {
    Name = "${var.name_tag_prefix}-ges-ec2"
  }
}

resource "aws_network_interface" "bastion-network-adapter" {
  subnet_id = "${var.ges_primary_subnet_id}"

  security_groups = [
    "${var.ges_primary_sg_id}",
  ]

  tags {
    Name = "${var.name_tag_prefix}-ges-ec2"
  }
}

resource "aws_s3_bucket" "bastion-log-s3-bucket" {
  bucket = "ges-bastion-log-s3-bucket"
  acl    = "private"
  force_destroy = true

  tags = {
    Name        = "ges-bastion-log-s3-bucket"
  }
}