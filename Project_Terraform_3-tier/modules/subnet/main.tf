resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_subnet
  availability_zone       = var.az_subnet
  map_public_ip_on_launch = var.public
  tags                    = var.tags_subnet
}
  
