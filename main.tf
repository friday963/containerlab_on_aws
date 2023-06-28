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

resource "aws_route_table" "containerlab_routetable" {
  vpc_id = aws_vpc.containerlab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.containerlab_igw.id
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.containerlab_routetable.id
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
    cidr_blocks = [data.aws_ip_ranges.region_specific_instance_connect.cidr_blocks[0], "${local.ip_address}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "containerlab_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}



resource "aws_key_pair" "containerlab_keypair" {
  key_name = var.key_pair_name
  public_key = tls_private_key.containerlab_key.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.containerlab_key.private_key_pem}' > ./${var.key_pair_name}.pem && chmod 600 ./${var.key_pair_name}.pem"
  }
}

resource "aws_instance" "containerlab_instance" {
  ami = var.containerlab_ami
  instance_type = var.containerlab_ami_instance_type
  subnet_id = aws_subnet.public.id
  security_groups = [aws_security_group.allow_ssh.id]
  user_data = file("userdata.txt")
  key_name = aws_key_pair.containerlab_keypair.key_name
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