variable "public_cidr" {
    type    = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "private_cidr" {
    type    = list(string)
    default = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
}

variable "availability_zone" {
type = string
default = "us-east-1a"
}
