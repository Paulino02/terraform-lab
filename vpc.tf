# 1 : Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# 2: Create a public subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "PublicSubnet"
  }
}

# 3 : create a private subnet
resource "aws_subnet" "PrivSubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet"
  }
}

# 4 : create IGW
resource "aws_internet_gateway" "myIgw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "MyIGW"
  }
}

# 5 : route Tables for public subnet
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

# 6 : route table association for public subnet 
resource "aws_route_table_association" "PublicRTAssociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

# 7: Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "NAT EIP"
  }
}

# 8: Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PublicSubnet.id
  tags = {
    Name = "NAT Gateway"
  }
}

# 9: Route Table for private subnet
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "PrivateRT"
  }
}

# 10: Route table association for private subnet
resource "aws_route_table_association" "PrivateRTAssociation" {
  subnet_id      = aws_subnet.PrivSubnet.id
  route_table_id = aws_route_table.PrivateRT.id
}

# Output VPC ID
output "vpc_id" {
  value = aws_vpc.myvpc.id
}

# Output Public Subnet ID
output "public_subnet_id" {
  value = aws_subnet.PublicSubnet.id
}

# Output Private Subnet ID
output "private_subnet_id" {
  value = aws_subnet.PrivSubnet.id
}

# Output NAT Gateway ID
output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}
