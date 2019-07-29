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
  insufficient_data_actions  = []
  treat_missing_data        = "notBreaching"
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
  insufficient_data_actions  = []
  treat_missing_data        = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_5XX_Count_alarm" {
  alarm_name                = "${var.app}-http5xx-${var.environment}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "HTTPCode_Target_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "25"
  alarm_description         = "HTTP 5XX alarm for over 25 counts within 5 minutes for ${var.app}"
  alarm_actions             = "${var.alert_actions}"
  ok_actions                = "${var.alert_actions}"
  insufficient_data_actions  = []
  treat_missing_data        = "notBreaching"
}