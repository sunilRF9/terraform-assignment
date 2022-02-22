# vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "main_gw"
  }
}

# rt
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0:/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main_rt"
  }
}

# Public and Private Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = var.public_cidr[count.index]
  count = length(var.public_cidr)

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]
  count = length(var.private_cidr)

  tags = {
    Name = "Private Subnet"
  }
}

# associate rt
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

#private nat
resource "aws_nat_gateway" "private_nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet.id
}

# sec group
resource "aws_security_group" "sg" {
vpc_id      = aws_vpc.main.id
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# eni
resource "aws_network_interface" "main_eni" {
  subnet_id       = aws_subnet.public_cidr.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.sg.id]
}

# eip
resource "aws_eip" "elastic_ip" {
  vpc                       = true
  network_interface         = aws_network_interface.main_eni.id
  associate_with_private_ip = "10.0.2.10"
  depends_on 	            = [aws_internet_gateway.gw]
}
