# 1: Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# 2: Create the first public subnet
resource "aws_subnet" "PublicSubnet1" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "PublicSubnet1"
  }
}

# 3: Create the second public subnet
resource "aws_subnet" "PublicSubnet2" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "PublicSubnet2"
  }
}

# 4: Create an Internet Gateway (IGW)
resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyIGW"
  }
}

# 5: Create a route table for public subnets
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIgw.id
  }

  tags = {
    Name = "PublicRT"
  }
}

# 6: Associate route table with the first public subnet
resource "aws_route_table_association" "PublicRTAssociation1" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRT.id
}

# 7: Associate route table with the second public subnet
resource "aws_route_table_association" "PublicRTAssociation2" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRT.id
}