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

resource "aws_network_acl" "core_acl" {
  vpc_id = aws_vpc.core_vpc.id
  
  #Allow all traffic
  egress {
    protocol = var.egress_allow_all.protocol
    to_port = var.egress_allow_all.to_port
    from_port = var.egress_allow_all.from_port
    action = "allow"
    rule_no = var.egress_allow_all.rule_no
    cidr_block = var.egress_allow_all.cidr_block_ipv4
  }

  #Allow only SSH traffic inbounds to my ip address
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = var.site #your ip address can only control ssh
  }
#This will deny any inbound traffic
  ingress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    rule_no = "200"
    action = "deny"
    cidr_block = "0.0.0.0/0"
    
  }

  tags = {
    Name = "core_acl"
  }
}


resource "aws_network_acl_association" "aws_networl_acl_a"{
  network_acl_id = aws_network_acl.core_acl.id
  subnet_id = aws_subnet.master.id

}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.core_vpc.id  
  tags = {
    Name = "Core_Internet_Gatway"
  }
}

//Creates route table and routes
//Check to see if this iteration is working <----------------------------------------------------------------
resource "aws_route_table" "core_rt" {
  vpc_id = aws_vpc.core_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "core-rt"
  }
  
}

// Association rt to the subnet
resource "aws_route_table_association" "core_rta" {
  subnet_id = aws_subnet.master.id
  route_table_id = aws_route_table.core_rt.id
  
}
//Security groups for the vpc
resource "aws_security_group" "egress_allow_all" {
  name ="allow_all_egress"
  description = "Security group will allow all traffic outbound"
  vpc_id = aws_vpc.core_vpc.id
  egress {
      from_port = var.egress_allow_all.from_port
      to_port = var.egress_allow_all.to_port
      protocol = var.egress_allow_all.protocol
      cidr_blocks = [var.egress_allow_all.cidr_block_ipv4]
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
  ingress  {
    from_port= var.ingress_allow_ssh_core.from_port
    to_port = var.ingress_allow_ssh_core.to_port
    protocol = var.ingress_allow_ssh_core.protocol
    cidr_blocks = [var.ingress_allow_ssh_core.cidr_block_ipv4]
  }
  tags = {
    Name = var.ingress_allow_ssh_core.tag
  }
}


resource "aws_security_group" "ingress_allow_ssh_site" {
  name="allow_ssh_inbound_ssh_site"
  description = "Allows ssh traffic inbound from personal site"
  vpc_id = aws_vpc.core_vpc.id
  ingress {
    from_port = var.ingress_allow_ssh_site.from_port
    to_port = var.ingress_allow_ssh_site.to_port
    protocol = var.ingress_allow_ssh_site.protocol
    cidr_blocks = [var.site]
  }
  tags = {
    Name  = var.ingress_allow_ssh_site.tag
  }
  
}

