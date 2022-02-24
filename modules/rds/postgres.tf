resource "aws_db_instance" "test_db" {
  instance_class         = var.instance_class
  allocated_storage      = var.storage
  engine                 = var.engine
  name                   = var.name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = var.db_subnet_group
  vpc_security_group_ids = [var.common_vpc_security_group]
}
