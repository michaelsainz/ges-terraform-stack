output "ges-instance-id" {
    value = "${aws_instance.ges-ec2.id}"
}

output "private-hostname" {
    value = "${aws_instance.ges-ec2.private_dns}"
}

output "public-dns" {
    value = "${aws_instance.ges-ec2.public_dns}"
}

output "private-ip" {
    value = "${aws_instance.ges-ec2.private_ip}"
}