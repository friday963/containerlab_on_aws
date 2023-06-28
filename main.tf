

provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

# module "compute" {
#   source = "./modules/compute"
# }

# module "security" {
#   source = "./modules/security"
# }
