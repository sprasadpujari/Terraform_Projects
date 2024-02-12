
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

#Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}

#Create Public subnet #1
resource "aws_subnet" "Public_sub2a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "Public_sub2a"
  }
}

#Create Public subnet #2
resource "aws_subnet" "Public_sub2b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"

  tags = {
    Name = "Public_sub2b"
  }
}

#Create Private subnet #1
resource "aws_subnet" "db_private_sub2a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2a"

  tags = {
    Name = "Db_Private_sub2a"
  }
}

#Create Private subnet #2
resource "aws_subnet" "Private_sub2b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Private_sub2b"
  }
}

#Create Internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main_IGW"
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

#Create Security group for VPC
resource "aws_security_group" "my_vpc_sg" {
  name        = "my_vpc_sg"
  description = "Allow inbound traffic to instance"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create a Security group for Database server
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allows inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.my_vpc_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Create an ALB target group
resource "aws_lb_target_group" "alb-TG" {
  name     = "alb-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

#Create Load balancer
resource "aws_lb" "my-aws-alb" {
  name               = "my-aws-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_vpc_sg.id]
  subnets            = [aws_subnet.Public_sub2a.id, aws_subnet.Public_sub2b.id]
}

# Create Load balancer listner rule
resource "aws_lb_listener" "lb_lst" {
  load_balancer_arn = aws_lb.my-aws-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-TG.arn
  }
}

#Load balancer-Target group attachment
resource "aws_lb_target_group_attachment" "my-aws-alb" {
  target_group_arn = aws_lb_target_group.alb-TG.arn
  target_id        = aws_instance.Pub2a_ec2.id
  port             = 80
}

#Load balancer-Target group attachment
resource "aws_lb_target_group_attachment" "my-aws-alb2" {
  target_group_arn = aws_lb_target_group.alb-TG.arn
  target_id        = aws_instance.Pub2b_ec2.id
  port             = 80
}

#Create EC2 instances in public subnets
resource "aws_instance" "Pub2a_ec2" {
  ami                         = "ami-08e2d37b6a0129927"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.Public_sub2a.id
  security_groups             = [aws_security_group.my_vpc_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>This Monolith terraform  project Code is finally Worked.EC2 instance launched in us-west-2a!!!</h1>" > var/www/html/index.html
    EOF
}

resource "aws_instance" "Pub2b_ec2" {
  ami                         = "ami-08e2d37b6a0129927"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.Public_sub2b.id
  security_groups             = [aws_security_group.my_vpc_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>This Monolith terraform  project Code is finally Worked..EC2 instance launched in us-west-2b!!!</h1>" > var/www/html/index.html
    EOF
}

# Create a Database instance
resource "aws_db_instance" "db_instance" {
  allocated_storage      = 10
  db_name                = "my_private_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "projectTerraform"
  password               = "Terraform1234"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "db_sub_grp"
  vpc_security_group_ids = [aws_security_group.my_vpc_sg.id]
  skip_final_snapshot    = true
}

#Create RDS instance subnet group
resource "aws_db_subnet_group" "db_sub_grp" {
  name       = "db_sub_grp"
  subnet_ids = [aws_subnet.db_private_sub2a.id, aws_subnet.Private_sub2b.id]
}
