data "template_file" "container_definitions" {
  template = <<EOF
  [
    {
      "name": "${var.container_name}",
      "image": "${var.container_image}",
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_host_port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.log_group}",
          "awslogs-region": "${var.log_region}",
          "awslogs-stream-prefix": "${var.family}-${var.service_name}"
        }
      }
    }
  ]
EOF
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.family}"
  container_definitions    = "${data.template_file.container_definitions.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${var.ecs_tast_execution}"
  task_role_arn            = "${var.ecs_tast_execution}"
}

# Get currect task revision

data "aws_ecs_task_definition" "task" {
  task_definition = "${aws_ecs_task_definition.task.family}"
}

# Service
resource "aws_ecs_service" "web" {
  name            = "${var.family}-${var.service_name}"
  task_definition = "${aws_ecs_task_definition.task.family}:${max("${aws_ecs_task_definition.task.revision}", "${data.aws_ecs_task_definition.task.revision}")}"
  desired_count   = "${var.task_desired_count}"
  launch_type     = "FARGATE"
  cluster         = "${var.ecs_cluster}"

  network_configuration {
    security_groups = ["${var.security_groups_ids}"]
    subnets         = ["${var.subnets_ids}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_host_port}"
  }
}
