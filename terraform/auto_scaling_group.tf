
resource "aws_autoscaling_group" "project_asg1" {
  name                      = "project-asg1"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
    launch_template {
    id      = aws_launch_template.lauch_template_P.id
    }
  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
    load_balancers = [aws_elb.auth_loadbalancer.name]

}


resource "aws_autoscaling_group" "project_asg2" {
  name                      = "project-asg2"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
    launch_template {
    id      = aws_launch_template.lauch_template_X.id
    }
  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
    load_balancers = [aws_elb.discount_loadbalancer.name]

}



resource "aws_autoscaling_group" "project_asg3" {
  name                      = "project-asg3"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
    launch_template {
    id      = aws_launch_template.lauch_template_Y.id
    }
  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }
    load_balancers = [aws_elb.items_loadbalancer.name]

}


resource "aws_autoscaling_policy" "cpu_policy1" {
  name                  = "cpu-policy1"
  autoscaling_group_name = aws_autoscaling_group.project_asg1.name

  # Change this to use TargetTrackingScaling
  policy_type          = "TargetTrackingScaling"

  # No need for scaling_adjustment, adjustment_type, or cooldown here
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0

    # Optional parameters
    # Set these as needed
  }
}

resource "aws_autoscaling_policy" "cpu_policy2" {
  name                  = "cpu-policy2"
  autoscaling_group_name = aws_autoscaling_group.project_asg2.name

  # Change this to use TargetTrackingScaling
  policy_type          = "TargetTrackingScaling"

  # No need for scaling_adjustment, adjustment_type, or cooldown here
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0

    # Optional parameters
    # Set these as needed
  }
}

resource "aws_autoscaling_policy" "cpu_policy3" {
  name                  = "cpu-policy3"
  autoscaling_group_name = aws_autoscaling_group.project_asg3.name

  # Change this to use TargetTrackingScaling
  policy_type          = "TargetTrackingScaling"

  # No need for scaling_adjustment, adjustment_type, or cooldown here
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0

    # Optional parameters
    # Set these as needed
  }
}


#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#     notification_metadata = jsonencode({
#       foo = "bar"
#     })

#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }