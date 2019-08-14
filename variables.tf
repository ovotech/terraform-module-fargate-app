/*
 * variables.tf
 * Common variables to use in various Terraform files (*.tf)
 */

# The AWS region to use for the dev environment's infrastructure
variable "region" {
  default = "eu-west-1"
}

# Tags for the infrastructure
variable "tags" {
  type = map(string)
}

# The application's name
variable "app" {
}

# The environment that is being built
variable "environment" {
}

# The port the container will listen on, used for load balancer health check
# Best practice is that this value is higher than 1024 so the container processes
# isn't running at root.
variable "container_port" {
  default = "80"
}

# The port the load balancer will listen on
variable "lb_port" {
  default = "80"
}

# The load balancer protocol
variable "lb_protocol" {
  default = "HTTP"
}

# Network configuration

# The VPC to use for the Fargate cluster
variable "vpc" {
}

# The private subnets, minimum of 2, that are a part of the VPC(s)
variable "private_subnets" {
}

# The public subnets, minimum of 2, that are a part of the VPC(s)
variable "public_subnets" {
}

# The docker image that will be deployed to ECS
variable "docker_image" {
  default = "nginx"
}

# List of actions to trigger when alerts are sent
variable "alert_actions" {
  description = "List of ARN of action to take on alarms, e.g. SNS topics"
  type        = "list"
  default     = []
}

# CPU Alert Threshold
variable "cpu_alert_threshold" {
  description = "Threshold which will trigger a alert when the cpu crosses"
  default     = "80"
}

# Memory Alert Threshold
variable "memory_alert_threshold" {
  description = "Threshold which will trigger a alert when the memory crosses"
  default     = "80"
}

# Graylog Port
variable "graylog_port" {
  default = "12202"
}

# Graylog Cidr Block
variable "graylog_cidr" {
  description = "Cidr Block for Graylog"
}
