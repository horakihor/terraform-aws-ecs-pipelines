########################
# Auto Scaling for ECS #
########################

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${var.ecs_cluster_name}/${var.family}-${var.service_name}"
  role_arn           = "${aws_iam_role.autoscaling_execution.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = ["aws_ecs_service.web"]
}

resource "aws_appautoscaling_policy" "ecs_policy_down" {
  name               = "${var.ecs_cluster_name}-${var.family}-${var.service_name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.ecs_cluster_name}/${var.family}-${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = -10
      metric_interval_upper_bound = 0
      scaling_adjustment = -3
    }

    step_adjustment {
      metric_interval_lower_bound = -20
      metric_interval_upper_bound = -10
      scaling_adjustment = -2
    }

    step_adjustment {
      metric_interval_upper_bound = -20
      scaling_adjustment = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name               = "${var.ecs_cluster_name}-${var.family}-${var.service_name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.ecs_cluster_name}/${var.family}-${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 10
      scaling_adjustment  = 1
    }

    step_adjustment {
      metric_interval_lower_bound = 10
      metric_interval_upper_bound = 20
      scaling_adjustment = 2
    }

    step_adjustment {
      metric_interval_lower_bound = 20
      scaling_adjustment = 3
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.ecs_cluster_name}-${var.family}-${var.service_name}-autoscaling"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "${var.family}-${var.service_name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.ecs_policy_up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.ecs_policy_down.arn}"]
}
