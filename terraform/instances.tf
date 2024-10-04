## client
resource "aws_inscance" "client" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.public.id]
    #subnet_id = ###
    tags = {
        Name = "client ec2"
    }
}

## auth
resource "aws_instance" "auth" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.private.id]
    #subnet_id = ###
    tags = {
        Name = "auth ec2"
    }
}

## discounts
resource "aws_instance" "discounts" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.private.id]
    #subnet_id = ###
    tags = {
        Name = "discounts ec2"
    }
}

## items
resource "aws_instance" "items" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.private.id]
    #subnet_id = ###
    tags = {
        Name = "items ec2"
    }
}

## haproxy
resource "aws_instance" "haproxy" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.public.id]
    #subnet_id = ###
    tags = {
        Name = "haproxy ec2"
    }
}