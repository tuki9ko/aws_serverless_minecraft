resource "aws_vpc" "minecraft" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.minecraft.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.minecraft.id
  tags = {
    Name = "minecraft-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.minecraft.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}