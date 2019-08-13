variable "aws_region" {
	description = "The AWS region that the resources will reside in"
	default = "us-west-1"
}

variable "aws_access_key" {
	description = "The AWS IAM User Access key that Terraform and AWS CLI will use to interact with the cloud endpoints"
}

variable "aws_secret_key" {
	description = "The AWS IAM User Secret key that Terraform and AWS CLI will use to interact with the cloud endpoints"
}

variable "ges_version" {
    description = "Version of GHE AWS AMI to use"
    type = "string"
}

variable "aws_ghe_subnet_cidr" {
	description = "The CIDR/network address space of the subnet for the primary GHE instance"
	default = "10.0.0.0/24"
}

variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
}

variable "instance_type" {
	description = "The EC2 instance type that the primary GHE instance will run on"
	type = "string"
}

variable "aws_az" {
    description = "The AWS availability zone for resources to be configured in"
    type = "string"
    default = "us-west-1a"
}

variable "ec2_key_name" {
    description = "This is the name of the key pair to use within AWS EC2"
    type = "string"
}

variable "ges_subnet_id" {
	description = "This is the string representing the subnet ID for the primary GES instance"
	type = "string"
}

variable "ges_sg_id" {
	description = "This is the string representing the security group for the primary GES instance"
	type = "string"
}

variable "vpc_id" {
    description = "String representing the vpc id to associate subnets"
    type = "string"
}

variable "license_url" {
	description = "This is the string representing the path to the GES license file"
	type = "string"
}

variable "private_key_path" {
	description = "This is the string representing the path to the private key of the AWS Keypair used for the EC2 instances"
	type = "string"
}

variable "ges_mgmt_password" {
	description = "This is the string of the password for the management portal"
	type = "string"
}

variable "count" {
	description = "This is the number of GES instances to create"
	default = 2
}

variable "ges_role" {
	description = "This is the role (primary, replica) of the GES instance"
	type = "string"
}

variable "primary_hostname" {
	description = "This is the string that represents the private hostname of the Primary GES instance"
	default = "localhost"
}

variable "public_hostname" {
	description = "This is the string that represents the public hostname of the load balancer and Primary GES instance"
}

variable "primary_ip" {
	description = "This is the string that represents the Primary GES instance IP address"
	default = "0.0.0.0"
}