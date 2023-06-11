resource "aws_vpc" "rails_vpc" {
  cidr_block           = "10.17.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Rails VPC"
  }
}

resource "aws_subnet" "sn-public-1" {
  vpc_id            = aws_vpc.rails_vpc.id
  availability_zone = "${var.aws_region}a"
  cidr_block        = "10.17.101.0/24"
  tags = {
    Name = "sn-public-1"
  }
}
resource "aws_subnet" "sn-public-2" {
  vpc_id            = aws_vpc.rails_vpc.id
  availability_zone = "${var.aws_region}b"
  cidr_block        = "10.17.102.0/24"
  tags = {
    Name = "sn-public-2"
  }
}
resource "aws_subnet" "sn-private-1" {
  vpc_id            = aws_vpc.rails_vpc.id
  availability_zone = "${var.aws_region}a"
  cidr_block        = "10.17.1.0/24"
  tags = {
    Name = "sn-private-1"
  }
}
resource "aws_subnet" "sn-private-2" {
  vpc_id            = aws_vpc.rails_vpc.id
  availability_zone = "${var.aws_region}b"
  cidr_block        = "10.17.2.0/24"
  tags = {
    Name = "sn-private-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rails_vpc.id
  tags = {
    Name = "Rails VPC IGW"
  }
}

resource "aws_route_table" "rt-rails" {
  vpc_id = aws_vpc.rails_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt-rails"
  }
}

resource "aws_route_table_association" "public_rt1" {
  subnet_id      = aws_subnet.sn-public-1.id
  route_table_id = aws_route_table.rt-rails.id
}
resource "aws_route_table_association" "public_rt2" {
  subnet_id      = aws_subnet.sn-public-2.id
  route_table_id = aws_route_table.rt-rails.id
}
resource "aws_route_table_association" "private_rt1" {
  subnet_id      = aws_subnet.sn-private-1.id
  route_table_id = aws_route_table.rt-rails.id
}
resource "aws_route_table_association" "private_rt2" {
  subnet_id      = aws_subnet.sn-private-2.id
  route_table_id = aws_route_table.rt-rails.id
}
