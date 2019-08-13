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
/*
variable "aws_session_token" {
	description = "The AWS IAM User Session (token) key that Terraform and AWS CLI will use to interact with the cloud endpoints"
}
*/
variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
	default = "env_dev"
}
/*
variable "ges_egress_subnet_id" {
	description = "String representing the subnet ID of the egress subnet"
}
*/