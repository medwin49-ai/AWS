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

resource "aws_eip" "nat_eip"{
}

resource "aws_nat_gateway" "nat"{

  allocation_id = aws_eip.nat_eip.id
  subnet_id = var.public_subnet
  tags = {
    Name = "public-nat-gateway"
  }
}

resource "aws_route" "nat_route_private"{

  route_table_id = var.route_table_private
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}