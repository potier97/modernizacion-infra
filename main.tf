provider "aws" {
  profile = "profile2024"
  region  = "us-east-1"
}

# ============================================
# === SERVICIOS DECLARADOS PARA EL BACKEND ===
# ============================================

# GENERAR LLAVE DE ENCRIPTADO
resource "aws_kms_key" "misw_tf_backend_kms_key" {
  description             = "Llave para encriptar datos de los objetos de los buckets"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

# ALIAS DE LA LLAVE
resource "aws_kms_alias" "misw_tf_backend_kms_key" {
  name          = "alias/misw_kms_backend_key_alias"
  target_key_id = aws_kms_key.misw_tf_backend_kms_key.key_id
}

# Backend para el control de la infraestructura
resource "aws_s3_bucket" "misw_tf_backend_s3_bucket" {
  bucket = var.bucket_backend_name
  tags   = var.bucket_backend_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "misw_tf_backend_sse_config" {
  bucket = aws_s3_bucket.misw_tf_backend_s3_bucket.id
  # Regla de encriptacion
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.misw_tf_backend_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# ============================================
# === DEFINICION DE LA VPC ===================
# ============================================

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "private_subnet-b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet-b"
  }
}

resource "aws_subnet" "private_subnet-c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private_subnet-c"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ============================================
# === INSTANCIAS =============================
# ============================================

module "ec2_instances" {
  source                  = "./modules/ec2"
  for_each                = { for instance in var.ec2_instance_data : instance.instance_name => instance }
  vpc_name                = each.value.vpc_name
  subnet_tags             = each.value.subnet_tags
  security_group_name     = each.value.security_group_name
  security_group_name_tag = each.value.security_group_name_tag
  key_pair_name           = each.value.key_pair_name
  key_pair_name_tag       = each.value.key_pair_name_tag
  instance_name           = each.value.instance_name
  instance_type           = each.value.instance_type
  ami_id                  = each.value.ami_id
  volume_size             = each.value.volume_size
  ingress_cidr_blocks     = each.value.ingress_cidr_blocks
  egress_cidr_blocks      = each.value.egress_cidr_blocks
  associate_public_ip     = each.value.associate_public_ip
  ec2_tags                = each.value.ec2_tags
}

# ============================================
# === RECURSOS DE RDS ========================
# ============================================


## GRUPO DE SEGURIDAD DE ACCESOS DE LA DB
resource "aws_security_group" "db_security_group" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "db-security-group"
  description = "Grupo de seguridad para la base de datos"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "grupo de seguridad origen "
    self        = false
    cidr_blocks = ["181.137.161.243/32"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    description     = "grupo de seguridad origen"
    self            = false
    cidr_blocks     = []
    security_groups = ["sg-008bf4495ea22df78", "sg-0409598cf9cac393d", "sg-0a18b21d783b707cf"]
  }

  timeouts {}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-security-group"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = ["subnet-0885191baa3ecf84f", "subnet-07db63990c5ab48d9", "subnet-0f0feafc0f45c46e5", "subnet-0a87d9fffb59d62eb"]
  tags       = var.db_subnet_tags
}


module "rds" {
  source               = "./modules/rds"
  tags                 = var.rds_tags
  rds_identifier       = var.rds_identifier
  rds_username         = var.rds_username
  rds_userpwd          = var.rds_userpwd
  rds_dbname           = var.rds_dbname
  db_subnet_group_name = var.db_subnet_group_name
  security_group_ids   = var.security_group_ids
}

# ============================================
# === COLAS DE MENSAJES=======================
# ============================================

module "sqs" {
  source                     = "./modules/sqs"
  for_each                   = { for instance in var.sqs_data : instance.name => instance }
  name                       = each.value.name
  visibility_timeout_seconds = each.value.visibility_timeout_seconds
  message_retention_seconds  = each.value.message_retention_seconds
  delay_seconds              = each.value.delay_seconds
  receive_wait_time_seconds  = each.value.receive_wait_time_seconds
  tags                       = each.value.tags
}
