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
    
    
   