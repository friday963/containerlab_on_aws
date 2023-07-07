
data "template_cloudinit_config" "create_unified_user" {
  part {
    content_type = "text/cloud-config"
    content      = <<-CLOUDCONFIG
      #cloud-config
      users:
        - name: "${var.ec2_user_name}"
          groups: sudo
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${tls_private_key.containerlab_key.public_key_openssh}
      CLOUDCONFIG
  }
}

resource "aws_instance" "containerlab_instance" {
  ami = var.containerlab_ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = [var.security_groups]
  user_data = data.template_cloudinit_config.create_unified_user.rendered
  key_name = aws_key_pair.containerlab_keypair.key_name
  tags = {
    "Name" = var.name
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

resource "null_resource" "shell_file_setup" {
  provisioner "local-exec" {
    command = "chmod +x create_host_file.sh && ./create_host_file.sh ${aws_instance.containerlab_instance.public_ip}"
  }
}