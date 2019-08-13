output "public-hostname" {
    value = "${aws_route53_record.primary.fqdn}"
}