variable "rds_identifier" {
  type        = string
  description = "El nombre de la instancia de RDS"
  # default     = "tatBackServices"
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

variable "tags" {
  type        = map(string)
  description = "Etiquetas generales para diferenciar la infra del sitio"
}

variable "db_subnet_group_name" {
  type        = string
  description = "Nombre del grupo de subredes de la base de datos"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Lista de IDs de los grupos de seguridad"
}