# Create a new load balancer
resource "aws_elb" "bar" {
  name               = var.loadbalancer_name
  availability_zones = [var.availability_zone["public_subnet_az"], var.availability_zone["private_subnet_az"]]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [aws_security_group.public.id, aws_security_group.private.id] 

  tags = {
    Name = var.loadbalancer_name
  }
}