output "misw_tf_backend_kms_key" {
  description = "ARN de llave para encriptar el backend de terra"
  value = aws_kms_key.misw_tf_backend_kms_key.arn
}

#IP PRIVADA DE LAS INSTANCIA(S) CREADAS
output "all_aws_instance_private_ip" {
  description = "Private IP of the EC2 instance"
  # value = module.ec2_instances.
  value = values(module.ec2_instances)[*].aws_instance_private_ip
}

#LLAVE PRIVADA PARA OBTENER LA CONTRASENIA
output "all_private_key" {
  description = "Private key of the EC2 instance"
  sensitive   = true
  value       = values(module.ec2_instances)[*].private_key
}