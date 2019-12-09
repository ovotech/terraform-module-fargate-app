Terraform module to provision a Fargate application.

This module includes DataDog integration and requires a Datadog API key.

This module creates a Fargate applicaiton with a CI/CD user, load balancer, alerts, dashboards and logs.

## Examples

See `/examples/`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app | The application's name | string | - | yes |
| certificate_arn | The ARN for the SSL certificate | string | - | yes |
| container_cpu | The number of cpu units to reserve for the container | number | 246 | no |
| container_memory | The amount of memory to allow the application container to use | number | 256 | no |
| container_memory_reservation | The amount of memory to reserve for the application container, it can exceed this | number | 128 | no |
| container_name | The name of the container to run | string | `app` | no |
| container_port | The port the container will listen on, used for load balancer health check Best practice is that this value is higher than 1024 so the container processes isn't running at root. | string | - | yes |
string | `quay.io/turner/turner-defaultbackend:0.2.0` | no |
| datadog_api_key | The DataDog API key for this applicaiton | string | - | yes |
| deregistration_delay | The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused | string | `30` | no |
| ecs_as_cpu_high_threshold_per | If the average CPU utilization over a minute rises to this threshold, the number of containers will be increased (but not above ecs_autoscale_max_instances). | string | `80` | no |
| ecs_as_cpu_low_threshold_per | If the average CPU utilization over a minute drops to this threshold, the number of containers will be reduced (but not below ecs_autoscale_min_instances). | string | `20` | no |
| ecs_autoscale_max_instances | The maximum number of containers that should be running. used by both autoscale-perf.tf and autoscale.time.tf | string | `8` | no |
| ecs_autoscale_min_instances | The minimum number of containers that should be running. Must be at least 1. used by both autoscale-perf.tf and autoscale.time.tf For production, consider using at least "2". | string | `1` | no |
| environment | The environment that is being built | string | - | yes |
| health_check | The path to the health check for the load balancer to know if the container(s) are ready | string | - | yes |
| health_check_interval | How often to check the liveliness of the container | string | `30` | no |
| health_check_matcher | What HTTP response code to listen for | string | `200` | no |
| health_check_timeout | How long to wait for the response on the health check path | string | `10` | no |
| https_port | The port to listen on for HTTPS, always use 443 | string | `443` | no |
| lb_port | The port the load balancer will listen on | string | `80` | no |
| lb_protocol | The load balancer protocol | string | `HTTP` | no |
| private_subnets | The private subnets, minimum of 2, that are a part of the VPC(s) | string | - | yes |
| public_subnets | The public subnets, minimum of 2, that are a part of the VPC(s) | string | - | yes |
| region | The AWS region to use for the dev environment's infrastructure Currently, Fargate is only available in `us-east-1`. | string | `us-east-1` | no |
| replicas | How many containers to run | string | `1` | no |
| tags | Tags for the infrastructure | map | - | yes |
| vpc | The VPC to use for the Fargate cluster | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb_dns | The load balancer DNS name |

### Docker instructions

From the `docker` directory

```sh
make terraform
```

### Developing

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!
