### Providers
variable "region" {
  type = string
  description = "Region for the VPC"
  default = "eu-north-1"
}

### VPC
variable "vpc_name" {
  type = string
  description = "Name for the VPC"
  default = "Main VPC"
}

variable "vpc_cidr_block" {
  type = string
  description = "CIDR block for the main vpc"
  default = "10.0.0.0/16"
}

### Subnet
variable "availability_zone" {
  type = map(string)
  description = "Availability zones for the subnets"
  default = {
    public_subnet_az  = "eu-north-1a"
    private_subnet_az = "eu-north-1b"
  }
}

#### Public Subnet
variable "public_subnet_cidr_block" {
  type = string
  description = "CIDR block for the public subnet"
  default = "10.0.1.0/24"
}

#### Private subnet
variable "private_subnet_cidr_block" {
  type = string
  description = "CIDR block for the private subnet"
  default = "10.0.2.0/24"
}