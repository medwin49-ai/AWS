terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {

  region = "us-east-2"
}

// Private VPC for master nodes EXAMPLE: Ansible, K3 , Jenkins, and Promethus
resource "aws_vpc" "private_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "Private Control VPC"
    }
}

//Subnet that will go inside the master vpc
resource "aws_subnet" "master" {
  vpc_id = aws_vpc.private_vpc.id
  cidr_block = "10.0.1.0/24"



  tags = {
    Name = "master-subnet"
  }
}

//Security groups for the vpc
// Allow TLS
resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    description = "allows tls inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.private_vpc.id

    tags = {
      Name = "Allow TLS"
    }
  
}

resource "aws_security_group" "egress_allow_all" {

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
  
}