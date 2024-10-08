resource "aws_launch_template" "lauch_template_P" {
  name = "lauch_template_P"
  image_id = var.ami

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.small"
  key_name = var.key_name

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = var.availability_zone["public_subnet_az"]
  }

  vpc_security_group_ids = [aws_security_group.private.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test-auth"
    }
  }

  user_data = filebase64("template_script.sh")
}

resource "aws_launch_template" "lauch_template_X" {
  name = "lauch_template_X"
  image_id = var.ami

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.small"
  key_name = var.key_name

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = var.availability_zone["public_subnet_az"]
  }

  vpc_security_group_ids = [aws_security_group.private.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test-discount"
    }
  }

  user_data = filebase64("template_script1.sh")
}

resource "aws_launch_template" "lauch_template_Y" {
  name = "lauch_template_Y"
  image_id = var.ami

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.small"
  key_name = var.key_name

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = var.availability_zone["public_subnet_az"]
  }

  vpc_security_group_ids = [aws_security_group.private.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test-items"
    }
  }

  user_data = filebase64("template_script2.sh")
}