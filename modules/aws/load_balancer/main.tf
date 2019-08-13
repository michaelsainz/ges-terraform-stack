resource "aws_lb" "primary" {
  name               = "${var.name_tag_prefix}-ges-lb-primary"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.ges_primary_subnet_id}"]

  enable_deletion_protection = false

  tags = {
    Name = "${var.name_tag_prefix}-ges-lb"
  }
}

# Management HTTPS
resource "aws_lb_listener" "primary-mgmthttps" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-mgmthttps.arn}"
  }
}

resource "aws_lb_target_group" "primary-mgmthttps" {
  name     = "${var.name_tag_prefix}-ges-lb-tg8443"
  port     = 8443
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-mgmt-https" {
  target_group_arn = "${aws_lb_target_group.primary-mgmthttps.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 8443
}

# Management HTTP
resource "aws_lb_listener" "primary-mgmthttp" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "8080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-mgmthttp.arn}"
  }
}

resource "aws_lb_target_group" "primary-mgmthttp" {
  name     = "${var.name_tag_prefix}-ges-lb-tg8080"
  port     = 8080
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-mgmt-http" {
  target_group_arn = "${aws_lb_target_group.primary-mgmthttp.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 8080
}

# End user HTTPS
resource "aws_lb_listener" "primary-https" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-https.arn}"
  }
}

resource "aws_lb_target_group" "primary-https" {
  name     = "${var.name_tag_prefix}-ges-lb-tg443"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-https" {
  target_group_arn = "${aws_lb_target_group.primary-https.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 443
}

# End user HTTP
resource "aws_lb_listener" "primary-http" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-http.arn}"
  }
}

resource "aws_lb_target_group" "primary-http" {
  name     = "${var.name_tag_prefix}-ges-lb-tg80"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-http" {
  target_group_arn = "${aws_lb_target_group.primary-http.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 80
}

# SSH - Git
resource "aws_lb_listener" "primary-gitssh" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-gitssh.arn}"
  }
}

resource "aws_lb_target_group" "primary-gitssh" {
  name     = "${var.name_tag_prefix}-ges-lb-tg22"
  port     = 22
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-gitssh" {
  target_group_arn = "${aws_lb_target_group.primary-gitssh.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 22
}

# SSH - Management
resource "aws_lb_listener" "primary-mgmtssh" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "122"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-mgmtssh.arn}"
  }
}

resource "aws_lb_target_group" "primary-mgmtssh" {
  name     = "${var.name_tag_prefix}-ges-lb-tg122"
  port     = 122
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-mgmtssh" {
  target_group_arn = "${aws_lb_target_group.primary-mgmtssh.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 122
}

# SMTP
resource "aws_lb_listener" "primary-smtp" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "25"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-smtp.arn}"
  }
}

resource "aws_lb_target_group" "primary-smtp" {
  name     = "${var.name_tag_prefix}-ges-lb-tg25"
  port     = 25
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-smtp" {
  target_group_arn = "${aws_lb_target_group.primary-smtp.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 25
}

# Git Protocol
resource "aws_lb_listener" "primary-gitproto" {
  load_balancer_arn = "${aws_lb.primary.arn}"
  port              = "9418"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.primary-gitproto.arn}"
  }
}

resource "aws_lb_target_group" "primary-gitproto" {
  name     = "${var.name_tag_prefix}-ges-lb-tg9418"
  port     = 9418
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    enabled = false
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "primary-gitproto" {
  target_group_arn = "${aws_lb_target_group.primary-gitproto.arn}"
  target_id        = "${var.ges_primary_instance_id}"
  port             = 9418
}