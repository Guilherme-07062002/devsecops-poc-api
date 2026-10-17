terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Criamos uma chave KMS gerenciada pelo cliente (CMK) para atender ao CKV_AWS_189
resource "aws_kms_key" "ebs_key" {
  description             = "Chave KMS para criptografia de volumes EBS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# 2. Atualizamos o volume EBS para utilizar a chave KMS personalizada
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs_key.arn # Associa a CMK criada acima

  tags = {
    Name = "DevSecOps-POC-Volume"
  }
}