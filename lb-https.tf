# adds an https listener to the load balancer
# (delete this file if you only want http)

# The port to listen on for HTTPS, always use 443
variable "https_port" {
  default = "443"
}

variable "certificate_arn" {}

variable "lb_tls_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.main[0].id
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.lb_tls_policy

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_security_group_rule" "ingress_lb_https" {
  type              = "ingress"
  description       = "HTTPS"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = var.lb_ingress_cidr_blocks
  security_group_id = aws_security_group.nsg_lb.id
}
