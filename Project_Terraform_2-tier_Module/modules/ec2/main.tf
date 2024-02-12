#Create EC2 instances in public subnets
resource "aws_instance" "demo_instance_1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.public_sub2a_id
  security_groups             = [var.my_vpc_sg_id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>This terraform two-tier Module project is finally Worked.EC2 instance launched in us-west-2a!!!</h1>" > var/www/html/index.html
    EOF
}

resource "aws_instance" "demo_instance_2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.public_sub2b_id
  security_groups             = [var.my_vpc_sg_id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>This terraform two-tier Module project is finally Worked..EC2 instance launched in us-west-2b!!!</h1>" > var/www/html/index.html
    EOF
}

# Create a Database instance
resource "aws_db_instance" "db_instance" {
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "projectTerraform"
  password               = "Terraform1234"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "db_sub_grp"
  vpc_security_group_ids = [var.my_vpc_sg_id]
  skip_final_snapshot    = true
}

#Create RDS instance subnet group
resource "aws_db_subnet_group" "db_sub_grp" {
  name       = "db_sub_grp"
  subnet_ids = [var.db_private_sub2a_id, var.Private_sub2b_id]
}
