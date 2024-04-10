
####### variables.tf #########

# variable for region
variable "region" {}

# variable for project name 
variable "project_name" {}

# variable for vpc cidr block
variable "vpc_cidr_block" {}

# variable for public subnet 1 cidr block 
variable "public_subnet_1_cidr_block" {}

# variable for public subnet 2 cidr block 
variable "public_subnet_2_cidr_block" {}

# variable for private subnet 1 cidr block
variable "private_subnet_1_cidr_block" {}

# variable for private subnet 2 cidr block 
variable "private_subnet_2_cidr_block" {}

# variable for public subnet 1 availability zone
variable "public_subnet_1_az" {}

# variable for public subnet 2 availability zone
variable "public_subnet_2_az" {}

# variable for private subnet 1 availability zone
variable "private_subnet_1_az" {}

# variable for private subnet 2 availability zone
variable "private_subnet_2_az" {}



######### compute/variable.tf #############

# variable for security group name
variable "sg-name" {}

# variable for instance type
variable "instance_type" {}

# variable for key pair
variable "keypair_name" {}


######### alb/variable.tf #############

# variable for load balancer security group name
variable "lb_sg_name" {}

# varibale for target group name
variable "tg_name" {}

# variable for load balancer name 
variable "lb_name" {}


######### database/variable.tf ##########

# variable for database security group name
variable "db_sg_name" {}

# variable for database subnet group name
variable "db_subnet_group_name" {}


# variable for database username
variable "db_username" {}

# variable for database password
variable "db_password" {}








