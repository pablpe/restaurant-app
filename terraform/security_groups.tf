

resource "aws_security_group" "public" {
  name   = "public"
  vpc_id = aws_vpc.main-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_allow_all]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_allow_all]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_allow_all]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_allow_all]
  }

  tags = {
    Name = "public security group"
  }
}
resource "aws_security_group" "private" {
  name   = "private"
  vpc_id = aws_vpc.main-vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_allow_all]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.public.id]
  }
  tags = {
    Name = "private security group"
  }
}