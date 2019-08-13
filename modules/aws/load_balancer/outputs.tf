output "lb-dnsname" {
    value = "${aws_lb.primary.dns_name}"
}

output "lb-arn" {
    value = "${aws_lb.primary.arn}"
}

output "lb-zone-id" {
    value = "${aws_lb.primary.zone_id}"
}