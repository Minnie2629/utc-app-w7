# vpc
resource "aws_vpc" "vpc1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    name="utc-app"
    team="wdp"
    env="dev"
  }
}
#Nat Gateway 

resource "aws_eip" "el1" {
  
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id = aws_subnet.public1.id
}

# public subnet
resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.1.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name="utc-public-subnet-1a"
  }
}

resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.2.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name="utc-public-subnet-1b"
  }
}

#private subnet
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.3.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name="utc-private-subnet-1a"
  }
}

resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.4.0/24"
  vpc_id = aws_vpc.vpc1.id
  tags = {
    name="utc-private-subnet-1b"
  }
}



# nat gateway
resource "aws_nat_gateway" "nat1" {
  subnet_id = aws_subnet.public1.id
}

#public route table
resource "aws_route_table" "rtpu" {
  vpc_id = aws_vpc.vpc1.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
}
}

#private route table
resource "aws_route_table" "rtpri" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

#public route and subnet association
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpu.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpu.id
}
# private route and subnet association
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.rtpri.id
}

resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.rtpri.id
}
