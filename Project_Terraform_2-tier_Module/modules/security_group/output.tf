output "my_vpc_sg_id" {
    value = aws_security_group.my_vpc_sg.id
  
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}