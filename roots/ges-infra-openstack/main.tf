provider "openstack" {
  user_name   = var.auth_username
  tenant_name = var.openstack_tenant
  password    = var.auth_pass
  auth_url    = var.auth_url
  region      = "dc1"
}

module "ghes-primary" {
  source = "../../modules/openstack/provision-ges"

  instance_size = var.flavor
  ssh_key_file = var.ssh_key_file
  network_id = module.network.network_id
  pri_ghes_image_name = var.pri_ghes_image_name
  pri_root_vol_size = var.pri_root_vol_size
  pri_data_vol_size = var.pri_data_vol_size
  floating_ip_pool = var.floating_ip_pool
}

module "network" {
  source = "../../modules/openstack/networking"

  ext_network_name = var.ext_network_name
}

resource "openstack_networking_secgroup_v2" "GHES-Primary" {
  name        = "GHES-Primary"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}

resource "openstack_networking_secgroup_rule_v2" "http-admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}

resource "openstack_networking_secgroup_rule_v2" "https-admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8443
  port_range_max    = 8443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh-admin" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 122
  port_range_max    = 122
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.GHES-Primary.id
}