# ec2.tf

resource "aws_key_pair" "my_keypair" {
  key_name   = var.keypair_name                                  
  public_key = tls_private_key.my_private_key.public_key_openssh # Use the public key generated from a TLS private key
}

resource "tls_private_key" "my_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# using resource to generate local file for private key 
resource "local_file" "private_key" {
  content  = tls_private_key.my_private_key.private_key_pem
  filename = "${path.module}/key/test-app-key.pem"
}


# using data to generate ubuntu AMI for the instances 
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# create instance 1 
resource "aws_instance" "my_server_1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet_1.id
  key_name        = aws_key_pair.my_keypair.key_name
  security_groups = [aws_security_group.my_sg.id]
  depends_on      = [aws_key_pair.my_keypair]
  user_data       = filebase64("user-data.sh")

  tags = {
    Name = "${var.project_name}_server_1"
  }

}

# create instance 2 
resource "aws_instance" "my_server_2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet_2.id
  key_name        = aws_key_pair.my_keypair.key_name
  security_groups = [aws_security_group.my_sg.id]
  depends_on      = [aws_key_pair.my_keypair]
  user_data       = filebase64("user-data.sh")

  tags = {
    Name = "${var.project_name}_server_2"
  }

}











