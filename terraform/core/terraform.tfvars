//Terraform tfvars
//The values of objects

//Main VPC
core_vpc = {
  cidr_block = "10.0.0.0/16"
}

igw = {
  cidr_block_ipv4 = "0.0.0.0/0"
}

//Allow all traffic outbound
egress_allow_all= {
  to_port = 0
  from_port = 0
  protocol = "-1"
  rule_no = 200
  cidr_block_ipv4 = "0.0.0.0/0"
  tag = "allow_all_outbound"
}

//Only allow traffic SSH inbound to core subnet
ingress_allow_ssh_core= {
  to_port = 22
  from_port = 22
  protocol = "tcp"
  cidr_block_ipv4 = "10.5.5.0/24"
  tag = "allow_ssh_core"
}


ingress_allow_ssh_site = {
  to_port = 22
  from_port = 22
  protocol = "tcp"
  #terrafrom will as user to input the public ip address
  tag = "allow_ssh_site"
}

