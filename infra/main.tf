# main.tf

provider "aws" {
  region = var.aws_region
}

# Gerar uma chave SSH usando o TLS
resource "tls_private_key" "tiny_airflow_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Criar o Key Pair na AWS com a chave pública
resource "aws_key_pair" "tiny_airflow_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.tiny_airflow_key.public_key
}

# Criar um Security Group que permite acesso SSH
resource "aws_security_group" "tiny_airflow_sg" {
  name        = "tiny-airflow-sg"
  description = "Permitir acesso SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Acesso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tiny-airflow-sg"
  }
}

# Obter a VPC padrão
data "aws_vpc" "default" {
  default = true
}

# Obter a Subnet pública padrão
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "tag:Name"
    values = ["*"]
  }
}

data "aws_subnet" "default" {
  id = data.aws_subnet_ids.default.ids[0]
}

# Obter a última AMI do Ubuntu 20.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # ID oficial da Canonical
}

# Criar a instância EC2
resource "aws_instance" "tiny_airflow" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.default.id
  security_groups        = [aws_security_group.tiny_airflow_sg.name]
  key_name               = aws_key_pair.tiny_airflow_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "tiny-airflow"
  }

}

