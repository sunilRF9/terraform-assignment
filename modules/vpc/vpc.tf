# vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# igw
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    name = "main_gw"
  }
}


# eip
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
}

# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_cidr)
  cidr_block              = element(var.public_cidr, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}
# private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_cidr)
  cidr_block              = element(var.private_cidr, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet"
  }
}

# Routing table for private subnet 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}
# Routing table for public subnet 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations 
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


# sec group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

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

  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
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

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  #subnet_ids = [for o in aws_subnet.private_subnet : o.id]
  subnet_ids = aws_subnet.private_subnet.*.id
}
