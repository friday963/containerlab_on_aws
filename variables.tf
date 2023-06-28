variable "region" {
  type = string
  default = "us-east-2"
  description = "Location all resources will be deployed into."
}

variable "vpc_cidr_block" {
  type = string
  default = "10.10.0.0/16"
  description = "CIDR block for the entire VPC."
}

variable "key_pair_name" {
  type = string
  default = "containerlab_key"
}

variable "subnet_cidr_block" {
  type = string
  description = "CIDR block for the subnet within the VPC."
  default = "10.10.1.0/24"
}
#Make sure this AMI is available in whatever region you've choosen.
#Specifically choose an AMI of type Amazon Linux 2 so you have the instance connect binary already installed.
#If you choose an AMI of some other type, install the instance connect binary yourself.
variable "containerlab_ami" {
  type = string
  default = "ami-01ba8fe702263d044"
}

variable "containerlab_ami_instance_type" {
    type = string
    default = "t2.micro"
}

