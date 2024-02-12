output "target_group_arn_id" {
    value = aws_lb_target_group.alb-TG.arn
  
}

output "alb_dns_name" {
  value = aws_lb.my-aws-alb.dns_name
}