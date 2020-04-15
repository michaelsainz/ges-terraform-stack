variable "pri_ghes_image_name" {
  description = "Image name that the instance will use"
  type = string
}

variable "region" {
  description = "The region where this infrastructure will be managed"
  type = string
  default = "dc1"
}

variable "pri_root_vol_size" {
  description = "Size in gigabytes of the root volume for the Primary GHES instance"
  type = number
  default = 200
}

variable "pri_data_vol_size" {
  description = "Size in gigabytes of the data volume for the Primary GHES instance"
  type = number
  default = 500
}

variable "instance_size" {
  description = "Size of the compute instance"
  type = string
}

variable "ssh_key_file" {
  description = "Path to the private key file"
  type = string
}

variable "network_id" {
  description = "The network ID to attach the GitHub instance to"
  type = string
}

variable "floating_ip_pool" {
  description = "The floating IP pool ID"
  type = string
}