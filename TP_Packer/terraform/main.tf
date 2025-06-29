terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0e272b8aeb1edfb30"
  instance_type = "t2.micro"

  tags = {
    Name = "FCS-Frontend"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0e272b8aeb1edfb30"
  instance_type = "t2.micro"

  tags = {
    Name = "FCS-Backend"
  }
}

resource "aws_instance" "database" {
  ami           = "ami-0d1daa90562224c99"
  instance_type = "t2.micro"

  tags = {
    Name = "FCS-Database"
  }
}