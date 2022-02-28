variable "instance_type" {
  default = "t2.micro"
  type    = string
}
variable "availability_zone" {
  type    = string
  default = "us-east-1"
}
variable "name" {
  default = "webserver-sunil"
}
variable "public_subnet_ec2" {

}
variable "common_vpc_security_group" {

}
