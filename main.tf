provider "aws" {
  region = var.region
}

resource "aws_vpc" "containerlab_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "containerlab vpc"
  }
}

resource "aws_internet_gateway" "containerlab_igw" {
  vpc_id = aws_vpc.containerlab_vpc.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.containerlab_vpc.id
  cidr_block = var.subnet_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_ssh" {
  name = "containerlab_allow_ssh"
  description = "Allows SSH access from instance connect"
  vpc_id = aws_vpc.containerlab_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [data.aws_ip_ranges.region_specific_instance_connect.cidr_blocks[0]]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "containerlab_instance" {
  ami = var.containerlab_ami
  instance_type = var.containerlab_ami_instance_type
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.allow_ssh.id]
  tags = {
    "Name" = "containerlab"
  }
}

resource "aws_network_acl_association" "associate_nacl_subnet" {
  network_acl_id = aws_network_acl.containerlab_nacl.id
  subnet_id = aws_subnet.public.id
}

resource "aws_network_acl" "containerlab_nacl" {
  vpc_id = aws_vpc.containerlab_vpc.id
  tags = {
    "Name" = "containerlab nacl"
  }

  egress {
      action = "allow"
      from_port = 0
      to_port = 0
      cidr_block = "0.0.0.0/0"
      protocol = "-1"
      rule_no = 100
  }
  ingress {
    action = "allow"
    from_port = 0
    to_port = 0
    cidr_block = "0.0.0.0/0"
    rule_no = 100
    protocol = "-1"
  }
  }