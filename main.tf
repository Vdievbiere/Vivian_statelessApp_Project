#terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

 # Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# data "aws_subnet_ids" "private" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Tier = "Private"
#   }
# }



module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_cidr
  public_subnets  = var.public_cidr

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

#Creating SG
module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id #we called the value of the output vpc id from the vpc modules

  ingress_cidr_blocks = ["10.10.0.0/16"]
}

#creating Ec2 Instance

resource "aws_instance" "web" {
  ami           = var.ami_ids
  #availability_zone = slice(data.aws_availability_zones.available.names, 0,3)
  availability_zone = var.azs[count.index]
  instance_type = var.instance_type
  count = length(var.ec2_name_tag)     ##https://stackoverflow.com/questions/71359239/terraform-how-to-output-multiple-value
  # subnet_id =data.aws_subnet_ids.private
  subnet_id = module.vpc.private_subnets[count.index]                                                                       

  tags = {
    Name = var.ec2_name_tag[count.index]
    
  }
}

#EC2 LB target group
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# ### TARGET GROUP ATTACHMENT
# resource "aws_lb_target_group_attachment" "web_tg_attach" {
#   target_group_arn = aws_lb_target_group.web_target_group.arn
#   target_id        = aws_instance.web[count.index]
#   port             = 80
# }

