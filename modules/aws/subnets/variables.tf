variable "aws_region" {
	description = "The AWS region that the resources will reside in"
    type = "string"
	default = "us-west-1"
}

variable "aws_access_key" {
	description = "The AWS IAM User Access key that Terraform and AWS CLI will use to interact with the cloud endpoints"
    type = "string"
}

variable "aws_secret_key" {
	description = "The AWS IAM User Secret key that Terraform and AWS CLI will use to interact with the cloud endpoints"
    type = "string"
}

variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
    type = "string"
	default = "env_dev"
}

variable "avail_zones" {
    description = "List of strings representing the availablility zone ID"
    type = "list"
    default = ["us-west-1a"]
}

variable "vpc_id" {
    description = "String representing the vpc id to associate subnets"
    type = "string"
}

variable "main_route_table_id" {
    description = "String representing the main route table ID"
    type = "string"
}

variable "default_route_table_id" {
    description = "String representing the default route table ID of the VPC"
    type = "string"
}

variable "vpc_igw_id" {
    description = "String representing the Internet Gateway ID attached to the VPC"
    type = "string"
}

variable "cidr_block" {
    description = "String representing the CIDR block to use"
    type = "string"
}