output "public_subnet_ec2" {
  value = aws_subnet.public_subnet.*.id
}

output "common_vpc_security_group" {
  value = aws_security_group.sg.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}
