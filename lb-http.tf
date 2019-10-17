
variable "http_port" {
  default = "80"
}

resource "aws_alb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_alb.main.id
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group_rule" "ingress_lb_http" {
  type              = "ingress"
  description       = "HTTP"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nsg_lb.id
}