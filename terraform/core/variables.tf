//variables file 
//Will contain descriptions and names

variable "region" {
  description = "AWS Region"
  type = string
  default = "us-east-2"
}

variable "vpc_core" {
  description = "The ID of the VPC where the security group will be created"
  
  type = object({
    vpc_id = string
    cidr_block = string
    region = string
  })
}


variable "master_subnet" {
  description = "Subnet will control all other subnets"
  type = string
  default = "10.5.5.0/24"
}

variable "site" {
  description = "Public IP address of site"
  type = string
  sensitive = true
}



variable "igw" {
  description = "Internet gateway"
  type = object({
    cidr_block_ipv4 = string
  })
}

variable "core_route_table" {
  description = "Table of all the routes of core"
  type = list(string)
}

variable "egress_allow_all" {
  description = "Security_group will allow all traffic outbounds"
  type = object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block_ipv4 = string 
    tag = string
  })
}

variable "ingress_allow_ssh_core" {
  description = "Allow ssh locally from core subnet"
  type = object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block_ipv4 = string
    tag = string
  })
}

variable "ingress_allow_ssh_site" {
  description = "Allow ssh from site network"
  type = object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block_ipv4 = string
    tag = string 
  })
  
}