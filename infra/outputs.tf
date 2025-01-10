# outputs.tf

output "public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.tiny_airflow.public_ip
}

output "public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.tiny_airflow.public_dns
}

output "private_key" {
  description = "Chave privada SSH para acessar a instância EC2"
  value       = tls_private_key.tiny_airflow_key.private_key_pem
  sensitive   = true
}
