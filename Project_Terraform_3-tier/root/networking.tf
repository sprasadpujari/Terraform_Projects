# vpc
module "my_vpc" {
    source = "./modules/vpc"
    cidr_vpc = var.cidr_vpc
    tags_vpc = var.tags_vpc

  
}

# Internet gateway
module "igw" {

    source = "./modules/internet_gateway"
    vpc_id = module.my_vpc.my_vpc_id
    tags_igw = var.tags_igw
  
}

# elastic_ip
module "eip" {
    source = "./modules/elastic_ip"
    tags = var.tags_eip
    igw = module.igw
}

# nat gateway

module "nat" {
source = "./modules/nat_gateway"
eip_id = module.eip.eip_id
tags_nat = var.tags_nat
nat_subnet_id =module.subnet-pub-1a.subnet_id
  
}

#route tables for public subnets
module "public_rt" {
    source = "./modules/route_tables"
    rt_tags = var.rt_tags_pub
    rt_cidr_block = var.rt_cidr_block_pub
    gateway_id = module.igw.my_igw_id
    vpc_id = module.my_vpc.my_vpc_id
  
}

#route tables for private subnets
module "private_rt" {
    source = "./modules/route_tables"
    rt_tags = var.rt_tags_priv
    rt_cidr_block = var.rt_cidr_block_priv
    gateway_id = module.nat.nat_id
    vpc_id = module.my_vpc.my_vpc_id
  
}