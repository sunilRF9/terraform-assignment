resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("$HOME/.ssh/id_rsa.pub")
}

resource "aws_instance" "webserver" {
    ami     =   var.ami
    instance_type   = var.instance_type
    key_name   = "deployer-key"
    availability_zone = var.availability_zone
}
