variable "name" {
  description = "Nombre de la cola de mensajes"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Tiempo de espera de visibilidad en segundos"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Tiempo de retención de mensajes en segundos"
  type        = number
  default     = 345600
}

variable "delay_seconds" {
  description = "Tiempo de retraso en segundos"
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "Tiempo de espera de recepción en segundos"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Etiquetas para las colas de SQS"
  type        = map(string)
  default     = {}
}
