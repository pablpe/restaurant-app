# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "elastic-ip" {
  domain = "vpc"
}

# Create a NAT Gateway in the Public Subnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public_subnet.id
}