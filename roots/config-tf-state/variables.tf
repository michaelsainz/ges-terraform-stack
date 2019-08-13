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
/*
variable "aws_session_token" {
	description = "The AWS IAM User Session (token) key that Terraform and AWS CLI will use to interact with the cloud endpoints"
    type = "string"
}
*/
variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
	default = "dev_test"
}