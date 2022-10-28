#declaring variables for subnets

variable "private_cidr" {
       type = list
       description = "private cidr variables"
       default= ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    }

variable "public_cidr" {
       type = list
       description = "public cidr variables"
       default= ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    }
    # Below is the variables blocks for Ec2
variable "ec2_name_tag" {
  default = ["web1", "web2","web3"]
}

variable "instance_type" {
            #   0          1          2
  default = "t2.micro"
}

variable "ami_ids" {
  default =  "ami-09d3b3274b6c5d4aa"
   
  }

variable "azs" { 
    default = {
        0 = "us-east-1a"
        1 = "us-east-1b"
        2 = "us-east-1c"
    }
}


    
   ##  Variable for VPC
   variable "vpc_cidr"{
      type = string
      default = "10.0.0.0/16"
   }

   # ##VPC ID 
   # # variable "vpc_id"{
   #    type = string
   #    default = module.vpc.vpc_id

   # }
 
