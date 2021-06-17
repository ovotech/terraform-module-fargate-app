
variable "http_port" {
  default = "80"
}

variable "lb_http_redirect" {
  default = true
}

resource "aws_alb_listener" "redirect_http_to_https" {
  count = var.lb_http_redirect ? 1 : 0

  load_balancer_arn = aws_alb.main[0].id
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
  count = var.lb_http_redirect ? 1 : 0

  type              = "ingress"
  description       = "HTTP"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = var.lb_ingress_cidr_blocks
  security_group_id = aws_security_group.nsg_lb.id
}
