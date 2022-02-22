variable "engine" {
  default = "postgres"
  type    = string
}
variable "instance_class" {
  default = "db.t2.micro"
  type    = string
}
variable "name" {
  default = "mydb"
  type    = string
}
variable "username" {
  default = "test"
  type    = string
}
variable "password" {
  default = "infracloud"
  type    = string
}
