/**
 * Elastic Container Service (ecs)
 * This component is required to create the Fargate ECS service. It will create a Fargate cluster
 * based on the application name and enironment. It will create a "Task Definition", which is required
 * to run a Docker container, https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html.
 * Next it creates a ECS Service, https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html
 * It attaches the Load Balancer created in `lb.tf` to the service, and sets up the networking required.
 * It also creates a role with the correct permissions. And lastly, ensures that logs are captured in CloudWatch.
 *
 * When building for the first time, it will install a "default backend", which is a simple web service that just
 * responds with a HTTP 200 OK. It's important to uncomment the lines noted below after you have successfully
 * migrated the real application containers to the task definition.
 */

# How many containers to run
variable "replicas" {
  default = "1"
}

variable "environment_vars" {}

# The name of the container to run
variable "container_name" {
  default = "app"
}

# The minimum number of containers that should be running.
# Must be at least 1.
# used by both autoscale-perf.tf and autoscale.time.tf
# For production, consider using at least "2".
variable "ecs_autoscale_min_instances" {
  default = "1"
}

# The maximum number of containers that should be running.
# used by both autoscale-perf.tf and autoscale.time.tf
variable "ecs_autoscale_max_instances" {
  default = "8"
}

variable "enable_datadog_log_forwarding" {
  default = false
}

locals {
  # default log config without datadog log forwarding
  default_log_config = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = "/fargate/service/${var.app}-${var.environment}"
      "awslogs-region"        = "eu-west-1"
      "awslogs-stream-prefix" = "ecs"
    }
    secretOptions = null
  }

  # config for datadog log forwarding
  datadog_logforwarding = {
    logDriver = "awsfirelens"
    options = {
      "Name" = "datadog"
      "Host" = "http-intake.logs.datadoghq.com"
      "TLS" = "on"
      "dd_service" = var.app
      "dd_tags" = var.datadog_tags
      "dd_source" = "fargate-app"
      "provider" = "ecs"
    }
    secretOptions = [
      {
        name = "apikey"
        valueFrom = var.datadog_api_key_from
      }]
  }

  # use datadog forwarding logging config if var.enable_datadog_log_forwarding is enabled, otherwise use the default cloudwatch awslogs
  app_log_config = var.enable_datadog_log_forwarding ? local.datadog_logforwarding : local.default_log_config

  # if datadog key is set then datadog agent with app container
  # else just app container def
  app_container = concat([module.app_container_definition.json_map_encoded], var.datadog_api_key_from != null ? [module.datadog_container_definition.json_map_encoded] : [] )

  # if enable_datadog_log_forwarding && datadog_api_key_from is set then set up awsFireLens -> datadog log forwarding
  # else empty config
  firelens_dd_app_container = var.enable_datadog_log_forwarding == true && var.datadog_api_key_from != null ? [module.aws_firelens_log_router.json_map_encoded] : []

  # merge and flatten decisions
  container_defs = flatten(concat(local.app_container,  local.firelens_dd_app_container))
}

resource "aws_ecs_cluster" "app" {
  name = "${var.app}-${var.environment}"
  tags = var.tags
}

resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}

module "aws_firelens_log_router" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.57.0"
  essential       = true
  container_image           = "amazon/aws-for-fluent-bit:latest"
  container_name            = "log_router"
  container_cpu            = "10"
  container_memory         = "50"
  start_timeout            = "30"
  stop_timeout             = "30"
  firelens_configuration = {
    type = "fluentbit"
    options = {
      "enable-ecs-log-metadata" = "true"
    }
  }
  port_mappings = [
    {
      containerPort = 8125
      hostPort      = 8125
      protocol      = "tcp"
    },
  ]
  container_memory_reservation = 50
  user = "0"
}

module "app_container_definition" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.57.0"
  container_name           = var.container_name
  container_image          = var.docker_image
  container_cpu            = var.container_cpu
  container_memory         = var.container_memory
  essential                = true
  readonly_root_filesystem = false
  environment              = var.environment_vars
  container_memory_reservation = var.container_memory_reservation
  secrets                  = var.secrets
  port_mappings = [
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }
  ]
  log_configuration = local.app_log_config
  start_timeout            = "30"
  stop_timeout             = "30"
}

module "datadog_container_definition" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.57.0"
  container_name           = "datadog-agent"
  container_image          = "datadog/agent:7.16.1"
  container_cpu            = "10"
  container_memory         = "128"
  container_memory_reservation = "128"
  start_timeout            = "30"
  stop_timeout             = "30"
  essential                = false
  readonly_root_filesystem = false
  environment = [
    {
      name  = "ECS_FARGATE",
      value = true
    },
    {
      name  = "DD_APM_ENABLED",
      value = true
    },
    {
      name  = "DD_TAGS"
      value = replace(var.datadog_tags,","," ")
    }
  ]
  secrets = [
    {
      name: "DD_API_KEY",
      valueFrom: var.datadog_api_key_from
    }
  ]
  port_mappings = [
    {
      containerPort = 8126
      hostPort      = 8126
      protocol      = "tcp"
    },
    {
      containerPort = 8125
      hostPort      = 8125
      protocol      = "udp"
    },
  ]
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  # defined in role.tf
  task_role_arn = aws_iam_role.app_role.arn

  # need to be a JSON string so merge defs and join to a JSON comma seperated array
  container_definitions = "[${join(",", local.container_defs)}]"

  tags = var.tags
}

resource "aws_ecs_service" "app" {
  name            = "${var.app}-${var.environment}"
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.replicas

  network_configuration {
    security_groups = [aws_security_group.nsg_task.id]
    subnets         = split(",", var.ecs_task_subnets)
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.id
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags                    = var.tags
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  # workaround for https://github.com/hashicorp/terraform/issues/12634
  depends_on = [aws_alb_listener.https]

  # [after initial apply] don't override changes made to task_definition
  # from outside of terrraform (i.e.; fargate cli)
  lifecycle {
    ignore_changes = [task_definition]
  }
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app}-${var.environment}-ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/${var.app}-${var.environment}"
  retention_in_days = "14"
  tags              = var.tags
}

resource "aws_iam_role_policy" "secretsRead_policy" {
  name = "secretsRead_policy"
  role = aws_iam_role.ecsTaskExecutionRole.name
  policy = data.aws_iam_policy_document.secretsRead_policy_document.json
}

data "aws_kms_alias" "ssm_key" {
  count = length(var.kms_key_aliases)
  name = var.kms_key_aliases[count.index]
}

data "aws_iam_policy_document" "secretsRead_policy_document" {
  statement {
    actions = [
      "ssm:GetParameters",
    ]
    resources = concat([var.datadog_api_key_from], var.secrets[*].valueFrom)
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:Decrypt"
    ]
    resources = data.aws_kms_alias.ssm_key[*].target_key_arn
  }
}
