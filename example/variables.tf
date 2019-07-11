#--------------------------------------------------------------
# General
#--------------------------------------------------------------
variable "team" {
  description = "Team name"
}

variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "The environment for the application e.g. production"
}

variable "vpc_id" {
  description = "The id of the VPC to deploy this into"
}

variable "public_subnets" {
  description = "A CSV string of the public subnets"
}

variable "private_subnets" {
  description = "A CSV string of the private subnets"
}

variable "app_name" {
  description = "The name of the application"
}

variable "certificate_arn" {
  description = "The ARN of a AWS certificate for the HTTPS Listner on the ALB"
}

variable "docker_image" {
  description = "The docker image to use"
  default = "nginx"
}

variable "health_check" {
  description = "The endpoint to check the health of the container"
  default = "/"
}

variable "replicas" {
  description = "The number of tasks to run"
  default = "1"
}

variable "container_port" {
  description = "The port on docker container that is hosting the application"
  default = "80"
}