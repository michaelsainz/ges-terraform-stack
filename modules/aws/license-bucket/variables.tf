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

variable "ges_license_path" {
	description = "This is the string representing the path to the GES license file"
	type = "string"
}

variable "name_tag_prefix" {
	description = "String prefix that uniquely identifies resources as part of the multi cloud solution"
    type = "string"
}

variable "vpc_id" {
    description = "String representing the vpc id to associate subnets"
    type = "string"
}

variable "ges_provisioning_script" {
    description = "String representing the path to the GES provisioning script file"
    type = "string"
}