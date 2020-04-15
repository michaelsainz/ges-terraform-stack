variable "pri_ghes_image_name" {
  description = "Image name"
  type = string
  default = "github-enterprise-2.18.5.qcow2"
}

variable "pri_root_vol_size" {
  description = "Size in gigabytes of the root volume for the Primary GHES instance"
  type = number
  default = 200
}

variable "pri_data_vol_size" {
  description = "Size in gigabytes of the data volume for the Primary GHES instance"
  type = string
  default = "500"
}

variable "flavor" {
  description = "The size or type of compute instance on the OpenStack infrastructure"
  type = string
  default = "m1.xlarge"
}

variable "region" {
  description = "The region where this infrastructure will be managed"
  type = string
  default = "dc1"
}

variable "ssh_key_file" {
  description = "Path of the SSH public key"
  type = string
  default = "~/.ssh/id_rsa.terraform"
}

variable "ssh_user_name" {
  description = "The username of the appliance"
  type = string
  default = "admin"
}

variable "auth_url" {
  description = "The authentication API for the OpenStack infrastructure"
  type = string
}

variable "auth_username" {
  description = "The username of the account on the OpenStack infrastructure to authenticate against the API"
  type = string
}

variable "auth_pass" {
  description = "The password/token of the account on the OpenStack infrastructure to authenticate against the API"
  type = string
}

variable "openstack_tenant" {
  description = "The tenant of the OpenStack infrastructure to use"
  type = string
}

variable "ext_network_name" {
  description = "The name of the OpenStack network that provides external HPE connectivity"
  type = string
}

variable "floating_ip_pool" {
  description = "The ID of the floating IP address pool to use"
  type = string
}