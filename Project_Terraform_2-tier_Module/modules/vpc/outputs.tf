output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.my_vpc.id

}

output "public_subnet_az1_id" {
    value = aws_subnet.Public_sub2a.id
  
} 

output "public_subnet_az2_id" {
  value = aws_subnet.Public_sub2b.id
}

output "private_subnet_az1_id" {
    value = aws_subnet.db_private_sub2a.id
  
}

output "private_subnet_az2_id" {

    value =aws_subnet.Private_sub2b.id
  
}

output "my_igw_id" {
  
  value = aws_internet_gateway.my_igw.id
}

output "project_name" {
  value = var.project_name
}
  

