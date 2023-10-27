
resource "aws_lb_target_group" "tg" {
  name     = "tf-http-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
## cat target_group_attachment.tf
# Attach the target group for "test" ALB

resource "aws_lb_target_group_attachment" "tga_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tga_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instance_2_id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb" "lb" {
  name               = "test-lb-tf"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_id]
#   vpc_id = var.vpc_id
#   subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets = var.subnets
  enable_deletion_protection = false
  tags = {
    Environment = "lab-2"
  }
}

