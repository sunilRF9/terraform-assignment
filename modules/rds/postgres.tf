resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = var.engine
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  subnet_group_name    = [aws_db_subnet_group.default.id]
}
