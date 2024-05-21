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

  region = var.region
}

// Private VPC for master nodes EXAMPLE: Ansible, K3 , Jenkins, and Promethus
resource "aws_vpc" "core_vpc" {
    cidr_block = var.core_vpc.cidr_block

    tags = {
      Name = "Private Control VPC"
    }
}

//Subnet that will go inside the master vpc
resource "aws_subnet" "master" {
  vpc_id = aws_vpc.core_vpc.id
  cidr_block = var.master_subnet
  tags = {
    Name = "master-subnet"
  }
}
//Security groups for the vpc
// Allow TLS
resource "aws_security_group" "egress_allow_all" {

  name ="allow_all_egress"
  description = "Security group will allow all traffic outbound"
  vpc_id = aws_vpc.core_vpc.id
  egress = {
      from_port = var.egress_allow_all.from_port
      to_port = var.egress_allow_all.to_port
      protocol = var.egress_allow_all.protocol
      cidr_block = [var.egress_allow_all.cidr_block_ipv4]
    }
    tags = {
      Name = var.egress_allow_all.tag
    }
}


#Allow SSH Locally from the master subnet
resource "aws_security_group" "ingress_allow_ssh_core" {

  name= "allow_ssh_traffic_local"
  description = "Security group will allow ssh traffic locally"
  vpc_id = aws_vpc.core_vpc.id

  ingress = {
    from_port= var.ingress_allow_ssh_core.from_port
    to_port = var.ingress_allow_ssh_core.to_port
    protocol = var.ingress_allow_ssh_core.protocol
    cidr_block = [var.ingress_allow_ssh_core.cidr_block]
  }

  tags = {
    name = var.ingress_allow_ssh_core.tag
  }


  
}

