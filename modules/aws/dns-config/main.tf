data "aws_route53_zone" "primary" {
  name         = "${var.zone_name}"
}

resource "aws_route53_record" "primary" {
    zone_id = "${data.aws_route53_zone.primary.zone_id}"
    name = "github.${data.aws_route53_zone.primary.name}"
    type = "A"
    
    alias {
        name = "${var.lb_dns}"
        zone_id = "${var.lb_zone_id}"
        evaluate_target_health = true
    }
}