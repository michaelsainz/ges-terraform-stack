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
	default = "dev_test"
}

variable "ingress_cidrs" {
	description = "The CIDR/network address space of the subnet for the primary GHE instance"
	default = ["10.0.0.0/24"]
}

variable "ges_version" {
    description = "Version of GHE AWS AMI to use"
    type = "string"
}

variable "instance_type" {
	description = "The EC2 instance type that the primary GHE instance will run on"
	type = "string"
    default = "c4.2xlarge"
}

variable "ec2_key_name" {
    description = "This is the name of the key pair to use within AWS EC2"
    type = "string"
}

variable "ges_license_path" {
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

variable "ges_provisioning_script" {
    description = "String representing the path to the GES provisioning script file"
    type = "string"
	default = "../../modules/aws/scripts/ges-provisioning-script.sh"
}

variable "route53_zone_name" {
	description = "String representing the DNA namespace"
	type = "string"
}