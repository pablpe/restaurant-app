# Create a new load balancer
resource "aws_elb" "auth_loadbalancer" {
  name               = var.loadbalancer_auth_name
  # availability_zones = [var.availability_zone["private_subnet_az"]]
  subnets = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  listener {
    instance_port     = 3001
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3001/api/auth"
    interval            = 10
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [aws_security_group.public.id] 

  tags = {
    Name = var.loadbalancer_auth_name
  }
}

# Create a new load balancer
resource "aws_elb" "discount_loadbalancer" {
  name               = var.loadbalancer_discount_name
  # availability_zones = [var.availability_zone["private_subnet_az"]]
  subnets = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  listener {
    instance_port     = 3002
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3002/api/discounts"
    interval            = 10
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [aws_security_group.public.id] 

  tags = {
    Name = var.loadbalancer_discount_name
  }
}

# Create a new load balancer
resource "aws_elb" "items_loadbalancer" {
  name               = var.loadbalancer_items_name
  # availability_zones = [var.availability_zone["private_subnet_az"]]
  subnets = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  listener {
    instance_port     = 3003
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3003/api/items"
    interval            = 10
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [aws_security_group.public.id] 

  tags = {
    Name = var.loadbalancer_items_name
  }
}