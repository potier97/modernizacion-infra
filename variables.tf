variable "backend_env" {
  type        = string
  description = "Ambiente al cual se esta haciendo referencia"
}

variable "bucket_backend_name" {
  type        = string
  description = "Nombre del bucket en s3 que controla la infra de terraform"
}

variable "bucket_backend_acl" {
  type        = string
  description = "Control de acceso al S3"
}

variable "bucket_backend_tags" {
  type        = map(any)
  description = "Etiquetas para distinguir el componente"
}

# ===================================================================
# ===================================================================
# ================= VARIABLES CONSTANTES PARA AWS ===================
# ===================================================================
# ===================================================================

variable "aws_region" {
  type        = string
  description = "Nombre del region de aws"
}

variable "aws_environment" {
  type        = string
  description = "Ambiente de los recursos"
}

variable "aws_tags" {
  type        = map(string)
  description = "Etiquetas generales para diferenciar la infra del sitio"
}

# ===================================================================
# ===================================================================
# ===================== INSTANCIAS DE AWS ===========================
# ===================================================================
# ===================================================================


# MAQUINAS QUE SE NECESITAN CREAR BAJO DEMANDA 
variable "ec2_instance_data" {
  description = "EC2 INSTANCES DATA LIST"
  type = list(object({
    vpc_name                = string
    subnet_tags             = string
    security_group_name     = string
    security_group_name_tag = string
    key_pair_name           = string
    key_pair_name_tag       = string
    instance_name           = string
    instance_type           = string
    ami_id                  = string
    volume_size             = number
    ingress_cidr_blocks     = list(string)
    egress_cidr_blocks      = list(string)
    associate_public_ip     = bool
    ec2_tags = object(
      {
        Name = string,
    })
  }))
  default = []
}

# ===================================================================
# ===================================================================
# ===================== RECURSOS DE RDS =============================
# ===================================================================
# ===================================================================

variable "rds_tags" {
  type        = map(string)
  description = "Etiquetas generales para diferenciar la infra del sitio"
}

variable "rds_identifier" {
  type        = string
  description = "El nombre de la instancia de RDS"
}

variable "rds_username" {
  type        = string
  description = "El nombre de usuario de la base de datos de RDS"
}

variable "rds_userpwd" {
  type        = string
  description = "La contraseña de la base de datos de RDS"
}

variable "rds_dbname" {
  type        = string
  description = "El nombre de la base de datos de RDS"
}

variable "db_subnet_group_name" {
  type        = string
  description = "Nombre del grupo de subredes de la base de datos"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Lista de IDs de los grupos de seguridad"
}

variable "db_subnet_tags" {
  type        = map(string)
  description = "Etiquetas para las subredes"
}

# ===================================================================
# ===================================================================
# ===================== RECURSOS DE SQS =============================
# ===================================================================
# ===================================================================

variable "sqs_data" {
  description = "SQS INSTANCES DATA LIST"
  type = list(object({
    name                       = string
    visibility_timeout_seconds = number
    message_retention_seconds  = number
    delay_seconds              = number
    receive_wait_time_seconds  = number
    tags = object(
      {
        Name = string,
    })
  }))
  default = []
}
