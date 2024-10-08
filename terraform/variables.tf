### Providers
variable "region" {
  type        = string
  description = "Region for the VPC"
  default     = "eu-north-1"
}

### VPC
variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
  default     = "Main VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the main vpc"
  default     = "10.0.0.0/16"
}

### Subnet
variable "availability_zone" {
  type        = map(string)
  description = "Availability zones for the subnets"
  default = {
    public_subnet_az  = "eu-north-1a"
    private_subnet_az = "eu-north-1b"
  }
}

#### Public Subnet
variable "public_subnet_name" {
  type        = string
  description = "Name for public subnet"
  default     = "public-subnet"
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

#### Private subnet
variable "private_subnet_name" {
  type        = string
  description = "Name for private subnet"
  default     = "private-subnet"
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

### Internet Gateway
variable "igw_name" {
  type        = string
  description = "Name for Internet gateway"
  default     = "igw"
}

### Route Tables
variable "cidr_allow_all" {
  type        = string
  description = "CIDR Block for all communication"
  default     = "0.0.0.0/0"
}

variable "public_route_table_name" {
  type        = string
  description = "Name for the public route table"
  default     = "public route table"
}

variable "private_route_table_name" {
  type        = string
  description = "Name for the private route table"
  default     = "private route table"
}

### EC2
variable "ami" {
  type        = string
  description = "Amazon Image ID for the ec2 instasnces"
  default     = "ami-08eb150f611ca277f"
}

variable "instance_type" {
  type        = string
  description = "Amazon instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Key pair for ec2"
}

### Loadbalancer
variable "loadbalancer_name" {
  type        = string
  description = "Name for the loadbalancer"
  default     = "restaurant-loadbalancer"
}

