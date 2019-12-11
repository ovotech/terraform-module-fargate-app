provider "aws" {
  region = var.region
}

module "fargate_app" {
  source = "../"

  providers = {
    aws = aws
  }

  region                = var.region
  app                   = var.app_name
  certificate_arn       = var.certificate_arn
  environment           = var.environment
  container_port        = var.container_port
  replicas              = var.replicas
  health_check          = var.health_check
  vpc                   = var.vpc_id
  ecs_task_subnets      = var.private_subnets
  load_balancer_subnets = var.public_subnets
  ecr_repository_name   = var.ecr_repository_name
  environment_vars = [
    {
      name  = "NODE_ENV",
      value = var.environment
    },
    {
      name  = "PORT",
      value = var.container_port
    }
  ]
  tags = {
    application = var.app_name
    environment = var.environment
    team        = var.team
  }
  docker_image    = var.docker_image
  graylog_cidr        = []
  datadog_api_key = null
}

output "fargate_app_lb" {
  value = "${module.fargate_app.lb_dns}"
}

output "fargate_app_cicd_keys" {
  # Output command to get the API and secret key for your CI/CD user
  value = "terraform state show module.fargate_app.aws_iam_access_key.cicd_keys"
}
