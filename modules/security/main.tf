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