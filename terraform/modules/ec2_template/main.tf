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

  region = "us-east-1"
}


//This instance is to be create with the following:
//Security Groups: Allow SSH from my own ip, Allow SSH from ansible instance, Allow outbound traffic to internet gateway
//ami: generic ubuntu image
// Windows key is the key name
// name will be terraformexample

resource "aws_instance" "instance1" {
  
  ami                         = "ami-04b70fa74e45c3917"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "subnet-0766e30cb66ecd7bd"
  key_name                    = "Windows Key"
  vpc_security_group_ids      = ["sg-052f19b52fcb7a40e", "sg-0fa542067c43747bc", "sg-0623577abca4be1af" ]

  tags = {
        Name = "TerraformExample"
        }
}

# //Output the public address and public dns
# output "instance_id" {
#   value       = aws_instance.instance1.id
#   description = "Shows the id of the instance created"
# }

# output "instance_public_dns"{

#   value  = aws_instance.instance1.public_dns
#   description = "Shows the public ip that is not elastic."
# }

