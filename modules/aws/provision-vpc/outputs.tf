output "vpc-id" {
    value = "${aws_vpc.main.id}"
}

output "main-route-table-id" {
    value = "${aws_vpc.main.main_route_table_id}"
}

output "default-route-table-id" {
    value = "${aws_vpc.main.default_route_table_id}"
}

output "vpc-igw-id" {
    value = "${aws_internet_gateway.primary.id}"
}