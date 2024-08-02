resource "aws_lb" "private_alb" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = var.alb_type
  security_groups    = [var.private_sg_id]
  subnets            = var.private_subnet_id
}

resource "aws_lb_target_group" "private_tg" {
  name        = "private-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "private_instance" {
  count            = 2
  target_group_arn = aws_lb_target_group.private_tg.arn
  target_id        = element(var.private_instance_id, count.index)
  port             = 80
}
