# create vpc

resource "aws_vpc" "vp1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  tags ={
    Name = "utc-app"
    Team = "wdp"
    env = "dev"
  }
}

# Internet gateway

resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.vp1.id
}

#public subnet 1
resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.1.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-public-subnet-1a"
  }
  
}
# public sub 2
resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.2.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-public-subnet-1b"
  }
}

#private subnet 1
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.3.0/24"
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-private-subnet-1a"
  }
}
# private sub 2
resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.4.0/24"
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-private-subnet-1b"
  }
}

#Nat Gateway 

resource "aws_eip" "el1" {
  
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id = aws_subnet.public1.id
}

# Public route table

resource "aws_route_table" "rtpu" {
  vpc_id = aws_vpc.vp1.id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
}

# private route table

resource "aws_route_table" "rtpri" {
  vpc_id = aws_vpc.vp1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

# route and public subnet association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpu.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpu.id
}

# route and private subnet association

resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private1.id  
  route_table_id = aws_route_table.rtpri.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.private2.id  
  route_table_id = aws_route_table.rtpri.id
}



%%%%% Terraform code for aws project week7 sunday class: %%%%%%%%%%%%%%%%
  
*** provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

**** backend.tf

terraform {
  backend "s3" {
    bucket = "w7-ks-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "locktable"
  }
}

*** vpc.tf

# create vpc

resource "aws_vpc" "vp1" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  tags ={
    Name = "utc-app"
    Team = "wdp"
    env = "dev"
  }
}

# Internet gateway

resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.vp1.id
}

#public subnet 1
resource "aws_subnet" "public1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.1.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-public-subnet-1a"
  }
  
}
# public sub 2
resource "aws_subnet" "public2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.2.0/24"
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-public-subnet-1b"
  }
}

#private subnet 1
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block = "172.120.3.0/24"
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-private-subnet-1a"
  }
}
# private sub 2
resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block = "172.120.4.0/24"
  vpc_id = aws_vpc.vp1.id
  tags={
    Name = "utc-private-subnet-1b"
  }
}
#Nat Gateway 
resource "aws_eip" "el1" {  
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id = aws_subnet.public1.id
}
# Public route table
resource "aws_route_table" "rtpu" {
  vpc_id = aws_vpc.vp1.id  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
}
# private route table
resource "aws_route_table" "rtpri" {
  vpc_id = aws_vpc.vp1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}
# route and public subnet association
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpu.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpu.id
}
# route and private subnet association
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private1.id  
  route_table_id = aws_route_table.rtpri.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.private2.id  
  route_table_id = aws_route_table.rtpri.id
}

**** ec2.tf

resource "aws_instance" "server1" {
  ami           = "ami-0195204d5dce06d99"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public1.id
  # security_groups = [aws_security_group.sg-demo.name]
  vpc_security_group_ids = [aws_security_group.sg-demo.id]
  key_name      = aws_key_pair.aws_key.key_name
  user_data     = file("server.sh")
  tags ={
    Name = "utc-app-inst"
  }
}

*** server.sh

#!/bin/bash
   sudo  yum update -y
   sudo  groupadd docker
   sudo  useradd John -aG docker 
   sudo  yum install git unzip wget httpd -y
   sudo  systemctl start httpd
   sudo  systemctl enable httpd
   sudo  cd /opt
   wget https://github.com/kserge2001/web-consulting/archive/refs/heads/dev.zip
   unzip dev.zip
   cp -r /opt/web-consulting-dev/* /var/www/html
    
**** security.tf

resource "aws_security_group" "sg-demo" {
    name = "webserver-sg"
    vpc_id = aws_vpc.vp1.id
    description = "Allow ssh and httpd"
    
    ingress {
        description = "allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow 8000"
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
 
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags= {
    env = "Dev"
  }
  depends_on = [ aws_vpc.vp1 ]
  
**** utc-key.tf
  
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
#Create the Key Pair
resource "aws_key_pair" "aws_key" {
  key_name   = "utc-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "utc-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem
}  

  
