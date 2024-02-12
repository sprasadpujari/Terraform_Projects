
module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
} 

module "security_group" {
  source = "../modules/security_group"
  vpc_id = module.vpc.vpc_id
    
}

module "application_load_balancer" {
  source = "../modules/application_load_balancer"
  project_name = module.vpc.project_name
  my_vpc_sg_id = module.security_group.my_vpc_sg_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id = module.vpc.vpc_id
  instance_1 = module.ec2.instance_1_id
  instance_2 = module.ec2.instance_2_id


}

module "ec2" {
  source = "../modules/ec2"
  project_name = var.project_name
  public_sub2a_id = module.vpc.public_subnet_az1_id
  public_sub2b_id = module.vpc.public_subnet_az2_id
  db_private_sub2a_id = module.vpc.private_subnet_az1_id
  Private_sub2b_id = module.vpc.private_subnet_az2_id
  my_vpc_sg_id = module.security_group.my_vpc_sg_id
  db_sg_id = module.security_group.db_sg_id
  db_name = var.db_name
  ami_id = var.ami_id
  instance_type = var.instance_type

}