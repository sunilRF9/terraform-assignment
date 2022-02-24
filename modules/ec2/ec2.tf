resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/sunil/.ssh/id_rsa.pub")
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "webserver" {
  count = length(var.public_subnet_ec2)
  subnet_id = element(var.public_subnet_ec2, count.index)
  security_groups = [var.common_vpc_security_group]
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  key_name          = "deployer-key"
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.name}-${count.index}"
  }
}
