resource "aws_cloudwatch_metric_alarm" "CPUUtilization_alarm" {
  alarm_name                = "${var.app}-cpu-${var.environment}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "${var.cpu_alert_threshold}"
  alarm_description         = "This metric monitors ECS CPU utilization for ${var.app}"
  alarm_actions             = "${var.alert_actions}"
  ok_actions                = "${var.alert_actions}"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "MemoryUtilization_alarm" {
  alarm_name                = "${var.app}-memory-${var.environment}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "${var.memory_alert_threshold}"
  alarm_description         = "This metric monitors ECS memory utilization for ${var.app}"
  alarm_actions             = "${var.alert_actions}"
  ok_actions                = "${var.alert_actions}"
  insufficient_data_actions = []
}