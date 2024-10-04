# Public routes
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = var.cidr_allow_all
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}


#Private routes
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

# Nat Gateway private route
resource "aws_route" "private-nat-route" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = var.cidr_allow_all
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
}