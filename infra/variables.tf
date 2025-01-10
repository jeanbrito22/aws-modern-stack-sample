# variables.tf

variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Nome do Key Pair a ser criado."
  type        = string
  default     = "tiny-airflow"
}

variable "ssh_cidr" {
  description = "CIDR permitido para acesso SSH."
  type        = string
  default     = "0.0.0.0/0" # Recomenda-se restringir para seu IP
}
