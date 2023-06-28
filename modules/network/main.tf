resource "aws_vpc" "containerlab_vpc" {
  # cidr_block = var.vpc_cidr_block
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
  # cidr_block = var.subnet_cidr_block
  cidr_block = var.subnet_cidr_block
  map_public_ip_on_launch = true
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