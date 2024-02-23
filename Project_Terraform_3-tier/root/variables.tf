
###########################
#networking_tf
###########################

#vpc variables
variable "cidr_vpc" {}
variable "tags_vpc" {}

#internet gateway variables 
variable "tags_igw" {}

#elastic_ip variable

variable "tags_eip" {}

# nat gateway variables 

variable "tags_nat" {}

#route table for public subnet

variable "rt_cidr_block_pub" {}
variable "rt_tags_pub" {}

#route table for private subnet

variable "rt_cidr_block_priv" {}
variable "rt_tags_priv" {}

#####################################
#appTier_tf

#############################
#subnet-1-public-ap-south-1a

# variable vpc_id {
#     type=string
# }

variable "cidr_subnet_1" {}

variable "az_subnet_1" {}

variable "tags_subnet_1" {}

variable "public_1" {}

#############################
#subnet-2-public-ap-south-1b

# variable vpc_id {
#     type=string
# }

variable "cidr_subnet_2" {}

variable "az_subnet_2" {}

variable "tags_subnet_2" {}

variable "public_2" {}

#############################
#subnet-3-public-ap-south-1a

# variable vpc_id {
#     type=string
# }

variable "cidr_subnet_3" {}

variable "az_subnet_3" {}

variable "tags_subnet_3" {}

variable "public_3" {}

#############################
#subnet-4-public-ap-south-1a

# variable vpc_id {
#     type=string
# }

variable "cidr_subnet_4" {}

variable "az_subnet_4" {}

variable "tags_subnet_4" {}

variable "public_4" {}

##############################
#security_group_sg_alb_app
variable "ingress_rules_app" {}
variable "sg_name_app" {}
variable "egress_rules_app" {}
variable "sg_description_app" {}
variable "tags_sg_app" {}

##############################
#Security_group_alb_web

variable "ingress_rules_web" {}
variable "sg_name_web" {}
variable "egress_rules_web" {}
variable "sg_description_web" {}
# variable "security_groups_web" {
#   type = list(any)
# }
variable "tags_sg_web" {}

##############################
#sg_web_server

variable "sg_name_web_server" {}
variable "egress_rules_web_server" {}
variable "sg_description_web_server" {}
variable "tags_sg_web_server" {}
##############################
#sg_app_server

variable "sg_name_app_server" {}
variable "egress_rules_app_server" {}
variable "sg_description_app_server" {}
variable "tags_sg_app_server" {}
##############################
#web alb
variable "tags_alb_web" {}
#app alb
variable "tags_alb_app" {}

##############################
#target group 
variable "tags_app_tg" {}
variable "tags_web_tg" {}

#Project region
variable "region" {}