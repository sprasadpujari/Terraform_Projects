
#Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc"
  }

}

#create Internet gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project_name}-igw"

  }
}

#use data source to get all availability zone
data "aws_availability_zones" "availability_zone" {}

#create public subnet-1

resource "aws_subnet" "Public_sub2a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.availability_zone.names[0]

  tags = {
    Name = "Public_sub2a"
  }
}

#Create Public subnet #2
resource "aws_subnet" "Public_sub2b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.availability_zone.names[1]
  tags = {
    Name = "Public_sub2b"
  }
}

#Create Private subnet #1
resource "aws_subnet" "db_private_sub2a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_az1_cidr
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.availability_zone.names[0]

  tags = {
    Name = "Db_Private_sub2a"
  }
}

#Create Private subnet #2
resource "aws_subnet" "Private_sub2b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.availability_zone.names[1]

  tags = {
    Name = "Private_sub2b"
  }
}


#Create Route Table for Public Subnets
resource "aws_route_table" "my_rt_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "My_Route_Table"
  }
}

#Associate public subnets with routing table
resource "aws_route_table_association" "Public_sub1_Route_Association" {
  subnet_id      = aws_subnet.Public_sub2a.id
  route_table_id = aws_route_table.my_rt_table.id
}

resource "aws_route_table_association" "Public_sub2_Route_Association" {
  subnet_id      = aws_subnet.Public_sub2b.id
  route_table_id = aws_route_table.my_rt_table.id
}

