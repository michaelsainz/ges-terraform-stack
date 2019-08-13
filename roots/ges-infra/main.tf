terraform {
  required_version = ">= 0.10, < 0.12"
}

# Account Setup
provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

provider "template" {
  version = "~> 1.0"
}

module "vpc-primary" {
  source = "../../modules/aws/provision-vpc"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"
}

module "load_balancer" {
  source = "../../modules/aws/load_balancer"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  vpc_id = "${module.vpc-primary.vpc-id}"
  ges_primary_subnet_id = "${module.subnet-primary-public.ges-subnet-id}"
  ges_primary_instance_id = "${module.ec2-ges-primary.ges-instance-id}"
}

# Primary
module "subnet-primary-public" {
  source = "../../modules/aws/subnets"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"
  
  vpc_id = "${module.vpc-primary.vpc-id}"
  main_route_table_id = "${module.vpc-primary.main-route-table-id}"
  default_route_table_id = "${module.vpc-primary.default-route-table-id}"
  vpc_igw_id = "${module.vpc-primary.vpc-igw-id}"
  cidr_block = "10.0.0.0/24"
}

module "sg-ges-primary" {
  source = "../../modules/aws/sg-ges-primary"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  vpc_id = "${module.vpc-primary.vpc-id}"
}

module "ec2-ges-primary" {
  source = "../../modules/aws/provision-ges"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  vpc_id = "${module.vpc-primary.vpc-id}"
  ges_subnet_id = "${module.subnet-primary-public.ges-subnet-id}"
  ges_version = "${var.ges_version}"
  instance_type = "${var.instance_type}"
  ec2_key_name = "${var.ec2_key_name}"
  ges_sg_id = "${module.sg-ges-primary.ges-primary-sg-id}"
  license_url = "${module.ges-license-s3-bucket.license-url}"
  private_key_path = "${var.private_key_path}"
  ges_mgmt_password = "${var.ges_mgmt_password}"
  ges_role = "master"
  public_hostname = "${module.dns-hosting.public-hostname}"
}

# Global
module "dns-hosting" {
  source = "../../modules/aws/dns-config"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  zone_name = "${var.route53_zone_name}"
  lb_dns = "${module.load_balancer.lb-dnsname}"
  lb_zone_id = "${module.load_balancer.lb-zone-id}"
}

module "ges-license-s3-bucket" {
  source = "../../modules/aws/license-bucket"

  name_tag_prefix = "${var.name_tag_prefix}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  ges_license_path = "${var.ges_license_path}"
  vpc_id = "${module.vpc-primary.vpc-id}"
  ges_provisioning_script = "${var.ges_provisioning_script}"
}