variable "vpc_cidr_block" {
  type = string
  default = "10.10.0.0/16"
  description = "CIDR block for the entire VPC."
}
variable "subnet_cidr_block" {
  type = string
  description = "CIDR block for the subnet within the VPC."
  default = "10.10.1.0/24"
}