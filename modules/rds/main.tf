## PRINCIPAL INSTANCIA DB
resource "aws_db_instance" "db_instance_services" {
  identifier                            = var.rds_identifier
  instance_class                        = "db.t3.micro"
  allocated_storage                     = 5
  engine_version                        = "15.7"
  engine                                = "postgres"
  username                              = var.rds_username
  password                              = var.rds_userpwd
  db_name                               = var.rds_dbname
  availability_zone                     = "us-east-1a"
  db_subnet_group_name                  = var.db_subnet_group_name
  vpc_security_group_ids                = var.security_group_ids
  port                                  = 5432
  tags                                  = var.tags
  skip_final_snapshot                   = true
}

