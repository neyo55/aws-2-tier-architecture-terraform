
# security-groups.tf

# create a security group for the instance 
resource "aws_security_group" "my_sg" {
  name        = var.sg-name
  description = "Allow inbound tls traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "All traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "${var.project_name}_security_group"
  }

}


# create a security group for the database
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Allow inbound TLS from my_sg"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.my_sg.id]
  }

  egress {
    description     = "Rule to allow connections to database from any instances this security group is attached to"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.my_sg.id]
    self            = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}_db_sg"
  }
}



# resource to create a security group for load balancer
resource "aws_security_group" "lb_sg" {
  name        = var.lb_sg_name
  description = "Allow inbound TLS traffic for the load balancer"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}_lb_sg"
  }
}






















# resource "aws_security_group" "sg" {
#   name        = var.sg-name
#   description = "Allow tls for inbound traffic"
#   vpc_id = aws_vpc.myvpc.id


#   ingress {
#     description      = "SSH from VPC"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     security_groups = [aws_security_group.lb-sg.id]
#   }

#   ingress {
#     description      = "HTTP from VPC"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     security_groups = [aws_security_group.lb-sg.id]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     description      = "Rule to allow connections to database from any instances this security group is attached to"
#     from_port        = 3306
#     to_port          = 3306
#     protocol         = "tcp"
#     security_groups  = [aws_security_group.db-sg.id]
#     self             = false
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }