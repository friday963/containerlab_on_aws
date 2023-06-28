
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
