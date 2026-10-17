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

# 1. Criação da Chave KMS
resource "aws_kms_key" "ebs_key" {
  description             = "Chave KMS para criptografia de volumes EBS"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# 2. Definição explícita da Política da Chave KMS (Resolve o CKV2_AWS_64)
resource "aws_kms_key_policy" "ebs_key_policy" {
  key_id = aws_kms_key.ebs_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::*:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# 3. Volume EBS vinculado à CMK
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs_key.arn

  tags = {
    Name = "DevSecOps-POC-Volume"
  }
}