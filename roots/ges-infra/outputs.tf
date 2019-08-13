output "public-dns-loadbalancer" {
    value = "${module.load_balancer.lb-dnsname}"
}

output "public-ges-mgmt-url" {
    value = "https://${module.load_balancer.lb-dnsname}:8443/setup/settings"
}

output "primary-ges-public-dns" {
    value = "${module.ec2-ges-primary.public-dns}"
}