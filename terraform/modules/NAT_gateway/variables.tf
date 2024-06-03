variable "region"{
    description = "The region where the script will run"
    type = string
    default = "us-east-1"
}

variable "aws_vpc_id"{
    description = "vpc id"
    type = string
    default = "vpc-05caae9fa80c63b1f"
}

variable "public_subnet"{

    description = "The public subnet that will assoicated to the nat gateway"
    type = string
    default = "subnet-0766e30cb66ecd7bd"
}


variable "route_table_private"{

    description = "The id of the private route route_table_id"
    type = string
    default = "rtb-01063fe1fe91d1613"
}

