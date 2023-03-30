resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr_block
 tags = {
   Name = var.vpc_name
 }
}

# will create 3 public subnets randomly assigned to availability zones specified in var.azs list
resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = true 
 tags = {
   Name = "My Public Subnet ${count.index + 1}"
   Environment = var.environment
 }
}
 
# will create 3 priviate subnets randomly assigned to availability zones specified in var.azs list
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 map_public_ip_on_launch = false 
 tags = {
   Name = "My Private Subnet ${count.index + 1}"
   Environment = var.environment
 }
}

#  will create 1 public subnet to host managment tools in var.azs[0])
resource "aws_subnet" "mgmt" {
 vpc_id            = aws_vpc.main.id
 cidr_block        = var.mgmt_subnet_cidrs
 availability_zone = element(var.azs, 0)
 map_public_ip_on_launch = true 
 tags = {
   Name = "mgmt subnet"
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

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route table associations for public subnets to use public routing table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Route table associations for mngt subnet to use the public routing table
resource "aws_route_table_association" "mgmt" {
  subnet_id      = aws_subnet.mgmt.id
  route_table_id = aws_route_table.public.id
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
