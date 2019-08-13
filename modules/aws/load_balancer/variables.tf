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
}

variable "ges_primary_subnet_id" {
    description = "This string represents the subnet id of the Primary GES instance"
    type = "string"
}

variable "vpc_id" {
    description = "String representing the vpc id to associate subnets"
    type = "string"
}

variable "ges_primary_instance_id" {
    description = "The string representing the AWS Instance ID of the Primary GES instance"
    type = "string"
}