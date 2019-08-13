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

variable "vpc_id" {
    description = "String representing the vpc id to associate subnets"
    type = "string"
}

variable "lb_arn" {
    description = "The string representing the ARN of the AWS NLB"
    type = "string"
}

variable "bastion_log_s3_bucket" {
	description = "The string representing the S3 bucket region to store logs from the bastion host"
	type = "string"
}