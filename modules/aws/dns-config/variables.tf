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

variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
	default = "dev_test"
}

variable "zone_name" {
    description = "This is the string representing the AWS Route 53 zone name"
    type = "string"
}

variable "lb_dns" {
    description = "This is the string representing the load balancer public DNS name"
    type = "string"
}

variable "lb_zone_id" {
    description = "This is the string representing the load balancer zone ID"
    type = "string"
}