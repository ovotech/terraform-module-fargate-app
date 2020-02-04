output "alb_zone_arn" {
  value = "${aws_alb.main.arn}"
}

output "alb_zone_id" {
  value = "${aws_alb.main.zone_id}"
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.main.arn}"
}

output "task_security_group_id" {
  value = "${aws_security_group.nsg_task.id}"
}

output "alb_security_group_id" {
  value = "${aws_security_group.nsg_lb.id}"
}
