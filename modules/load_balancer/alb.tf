data "aws_security_group" "default_sg" {
  vpc_id = var.vpc_id
  name   = "default"
}

resource "aws_lb" "this" {
  name_prefix        = "hillel"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id, data.aws_security_group.default_sg.id]
  subnets            = var.subnet_ids_list
  enable_http2       = false
  ip_address_type    = "ipv4"
  tags               = var.tags
}

resource "aws_lb_target_group" "this" {
  name_prefix          = "hillel"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_listener" "plain_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}


