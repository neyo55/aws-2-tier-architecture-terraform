# alb.tf

# resource to create application load balancer
resource "aws_lb" "test" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Environment = "production"
  }
}

# resource to create alb listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# resource to create a target group
resource "aws_lb_target_group" "target_group" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

# resource to attach target group to instance 1
resource "aws_lb_target_group_attachment" "tg_attachment_1" {
  target_group_arn = aws_lb_target_group.target_group.id
  target_id        = aws_instance.my_server_1.id
  port             = 80
}

# resource to attach target group to instance 2
resource "aws_lb_target_group_attachment" "tg_attachment_2" {
  target_group_arn = aws_lb_target_group.target_group.id
  target_id        = aws_instance.my_server_2.id
  port             = 80
}




























# # resource to create a security group for load balancer
# resource "aws_security_group" "lb-sg" {
#   name        = var.lb-sg-name
#   description = "Allow tls for inbound traffic"
#   vpc_id = aws_vpc.my_vpc.id

#   ingress {
#     description      = "HTTP from VPC"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "${var.project_name}_lb_sg"
#    }
# }
































# # create application load balancer 
# resource "aws_lb" "alb" {
#   name               = "project-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.alb_sg]
#   subnets            = var.alb_subnets[*]


#   tags = {
#     Name = "${var.project_name}_alb"
#   }
# }

# # create target group
# resource "aws_lb_target_group" "alb_target_group" {
#   name     = "project-target-group"
#   port     = 80
#   target_type = "instance"
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id

#   health_check {
#     enabled             = true
#     healthy_threshold   = 5
#     unhealthy_threshold = 5
#     timeout             = 60
#     matcher             = 200
#     interval            = 300
#     path                = "/"
#   }

#   tags = {
#     Name = "${var.project_name}_target_group"
#   }
# }

# # create target group attachement 
# resource "aws_lb_target_group_attachment" "target_group_attachment" {
#   count = length(var.public_subnets_cidr)
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = var.ec2_ids[count.index]
# }

# # create listener on port 80 with a forward action 
# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }

# # using data to retrieve route53 details
# data "aws_route53_zone" "my_host_zone" {
#   name         = var.domain_name
#   private_zone = false
# }

# # create route53 record
# resource "aws_route53_record" "my_subdomain_1" {
#   zone_id = data.aws_route53_zone.my_host_zone.zone_id
#   name    = var.subdomain_name_1
#   type    = "A"

#   alias {
#     name                   = aws_lb.alb.dns_name
#     zone_id                = aws_lb.alb.zone_id
#     evaluate_target_health = true
#   }
# }






