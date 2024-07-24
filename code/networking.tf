# VPC Configuration

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "parrot-vpc"
  }
}

# Private Subnet 1

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "parrot-vpc-private"
  }
}

# Private Subnet 2

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "parrot-vpc-private2"
  }
}

# Public Subnet 1

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "parrot-vpc-public"
  }
}

# Public Subnet 2

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "parrot-vpc-public2"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "parrot-vpc-igw"
  }
}

# Public Route Table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "parrot-public-route-table"
  }
}

# Public Route Table Association for Public Subnet 1

resource "aws_route_table_association" "public_association1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}

# Public Route Table Association for Public Subnet 2

resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Elastic IP for NAT Gateway

resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway in Public Subnet 1

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "parrot-nat-gateway"
  }
}

# Private Route Table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "parrot-private-route-table"
  }
}

# Private Route Table Association for Private Subnet 1

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

# Private Route Table Association for Private Subnet 2

resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_route_table.id
}
