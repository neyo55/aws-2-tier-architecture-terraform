# db-main.tf

resource "aws_db_instance" "db_1" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db_username  #"neyo"
  password               = var.db_password  #"neyo55"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.subnet_grp.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}


# resource to create a subnet group for the database
resource "aws_db_subnet_group" "subnet_grp" {
  name       = var.db_subnet_group_name
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "${var.project_name}_db_subnet_group"
  }
}





