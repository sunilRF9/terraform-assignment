variable "db_subnet_group" {
}

variable "common_vpc_security_group" {
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "storage" {
  default = "5"
}

variable "engine" {
  default = "postgres"
}

variable "name" {
  default = "testdb"
}

variable "username" {
  default = "infracloud"
}

variable "password" {
  default = "citadel12345"
}
