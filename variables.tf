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
variable "ecs_task_subnets" {
}

# The public subnets, minimum of 2, that are a part of the VPC(s)
variable "load_balancer_subnets" {
}

# The docker image that will be deployed to ECS
variable "docker_image" {
  default = "nginx"
}

# List of actions to trigger when alerts are sent
variable "alert_actions" {
  description = "List of ARN of action to take on alarms, e.g. SNS topics"
  type        = list
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

variable "task_cpu" {
  default     = "256"
  description = "The number of cpu units to reserve for the task, must be higher than the all the CPU in the containers in the task"
}

variable "task_memory" {
  default     = "512"
  description = "The amount of memory (in MiB) to allow the task to use. Must be higher than all the containers in the task"
}

variable "container_memory" {
  type        = number
  default     = "384"
  description = "The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
}

variable "container_memory_reservation" {
  type        = number
  default     = "128"
  description = "The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
}

variable "container_cpu" {
  type        = number
  default     = "246"
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
}

variable "datadog_api_key" {
  type        = string
  description = "The DataDog API key for this applicaiton"
}
