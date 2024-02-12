#Create an ALB target group
resource "aws_lb_target_group" "alb-TG" {
  name     = "${var.project_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

#Create Load balancer
resource "aws_lb" "my-aws-alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.my_vpc_sg_id]
  subnets            = [var.public_subnet_az1_id,var.public_subnet_az2_id]
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
  target_id        = var.instance_1
  port             = 80
}

#Load balancer-Target group attachment
resource "aws_lb_target_group_attachment" "my-aws-alb2" {
  target_group_arn = aws_lb_target_group.alb-TG.arn
  target_id        = var.instance_2
  port             = 80
}