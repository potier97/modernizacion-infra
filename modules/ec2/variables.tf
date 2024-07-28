# se redefine para el modulo de ec2_instances
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = ""
}

variable "subnet_tags" {
  description = "value of the subnet tags"
  type        = string
  default     = ""
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = ""
}

variable "security_group_name_tag" {
  description = "Tags of the security group"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "Name of the key pair for the EC2 instance"
  type        = string
  default     = ""
}

variable "key_pair_name_tag" {
  description = "Tags of the key pair for the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID of the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "Volume size of the EC2 instance"
  type        = number
}

variable "ingress_cidr_blocks" {
  description = "Ingress CIDR blocks of the EC2 instance"
  type        = list(string)
}

variable "egress_cidr_blocks" {
  description = "Egress CIDR blocks of the EC2 instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Associate public IP"
  type        = bool
  default     = false
}

variable "ec2_tags" {
  description = "Tags of the EC2 instance"
  type        = map(string)
  default     = {}
}



