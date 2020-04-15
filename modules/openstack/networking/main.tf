data "openstack_networking_network_v2" "ExtNet" {
  name = var.ext_network_name
}

resource "openstack_networking_network_v2" "GitHub" {
  name = "ghes-primary"
  external = "false"
}

resource "openstack_networking_subnet_v2" "ghes-primary-subnet" {
  name          = "ghes-primary-subnet"
  network_id    = openstack_networking_network_v2.GitHub.id
  cidr = "172.16.0.0/24"
}

resource "openstack_networking_router_v2" "generic" {
  name                = "router-generic"
  external_network_id = data.openstack_networking_network_v2.ExtNet.id
}