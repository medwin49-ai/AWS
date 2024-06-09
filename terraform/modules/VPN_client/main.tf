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
  region =  "us-east-1"
}

//Creates the VPN endpoint for VPN client

resource "aws_ec2_client_vpn_endpoint" "core-vpn" {


    description = "terraform-clietnvpn-corevpn"
    
    //server certificate (Certificate Manager)
    server_certificate_arn = "arn:aws:acm:us-east-1:621554089814:certificate/6f30c71f-f669-4a07-8340-9d5932dfd920"
    client_cidr_block =  "10.0.4.0/22"
    
    vpc_id= "vpc-05caae9fa80c63b1f"

    //Split_tunnel - allow user to use his own internet while being on the vpn
    split_tunnel = true

    connection_log_options {

        enabled = false

    }
    authentication_options {
        //local certifcate (Certificate Manager)
        type = "certificate-authentication"
        root_certificate_chain_arn = "arn:aws:acm:us-east-1:621554089814:certificate/e082244b-fdef-4091-9fa6-56d6c324610d"
    
    }

}

// After the VPN endpoint is done, we need to associate the vpn to the subnet we want to use
resource "aws_ec2_client_vpn_network_association" "vpn_association"{

    client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.core-vpn.id
    subnet_id = "subnet-0c60eff42103b146e"
}


resource "aws_ec2_client_vpn_authorization_rule" "vpn_authorization"{
    client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.core-vpn.id
    target_network_cidr = "0.0.0.0/0"
    authorize_all_groups = true

}