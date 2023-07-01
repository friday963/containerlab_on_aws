
locals {
  yaml_file = yamldecode(file("./vars.yml"))
}

provider "aws" {
  region = local.yaml_file.region
}

module "network" {
  source = "./modules/network"
  vpc_cidr_block = local.yaml_file.vpc_cidr_block
  subnet_cidr_block = local.yaml_file.subnet_cidr_block
  region = local.yaml_file.region
  
}

module "compute" {
  source = "./modules/compute"
  instance_type = local.yaml_file.ec2_instance_type
  containerlab_ami = local.yaml_file.ami_id
  key_pair_name = local.yaml_file.key_pair_name
  subnet_id = module.network.subnet_id
  security_groups = module.network.security_group_id
  name = local.yaml_file.containerlab_naming_convention
}

