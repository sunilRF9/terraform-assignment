variable "public_cidr" {
    type    = list(string)
    default = ["10.0.1.0/16","10.0.2.0/16","10.0.3.0/16"]
}

variable "private_cidr" {
    type    = list(string)
    default = ["10.0.4.0/16","10.0.5.0/16","10.0.6.0/16"]
}

variable "availability_zone" {
type = string
default = "us-east-1a"
}
