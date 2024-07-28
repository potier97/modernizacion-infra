data "aws_vpc" "priciapal_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private_subnet_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_tags]
  }
}

resource "aws_security_group" "ec2_instance_security_group" {
  name        = var.security_group_name
  description = "Allow RDP from VPN and others"
  vpc_id      = data.aws_vpc.priciapal_vpc.id

  tags = {
    Name = var.security_group_name_tag
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }


  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }
}

# Below Code will generate a secure private key with encoding
resource "tls_private_key" "ec2_instance_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "ec2_instance_keypair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_instance_key_pair.public_key_openssh
  tags       = {
    Name = var.key_pair_name_tag
  }
}

//DECLARACION DE UNA INSTANCIA  Y UNA IP PUBLICA
resource "aws_instance" "ec2_sb_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_instance_keypair.key_name
  subnet_id     = data.aws_subnet.private_subnet_vpc.id
  root_block_device {
    volume_size = var.volume_size
  }
  depends_on                  = [aws_security_group.ec2_instance_security_group]
  vpc_security_group_ids      = [aws_security_group.ec2_instance_security_group.id]
  associate_public_ip_address = var.associate_public_ip
  tags                        = var.ec2_tags
}

#IP PRIVADA DE LAS INSTANCIA(S) CREADAS
output "aws_instance_private_ip" {
  value = aws_instance.ec2_sb_instance.private_ip
}

output "private_key" {
  value = tls_private_key.ec2_instance_key_pair.private_key_pem
}
