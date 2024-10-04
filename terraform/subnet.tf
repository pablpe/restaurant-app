resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main-vpc.id

  cidr_block = var.public_subnet_cidr_block

  map_public_ip_on_launch = true

  availability_zone = var.availability_zone["public_subnet_az"]

  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main-vpc.id

  map_public_ip_on_launch = false

  availability_zone = var.availability_zone["private_subnet_az"]

  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = var.private_subnet_name
  }
}
