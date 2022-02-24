variable "instance_type" {
  default = "t2.micro"
  type    = string
}
variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}
variable "name" {
  default = "webserver"
}
variable "public_subnet_ec2" {

}
variable "common_vpc_security_group" {

}
