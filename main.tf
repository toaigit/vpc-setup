resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr_block
 tags = {
   Name = var.vpc_name
 }
}

resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true 
 tags = {
   Name = "Toai Public Subnet ${count.index + 1}"
   Environment = var.environment
 }
}
 
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = false 
 tags = {
   Name = "Toai Private Subnet ${count.index + 1}"
   Environment = var.environment
 }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route table associations for both Public
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
