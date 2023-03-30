# Default Security Group of VPC
resource "aws_security_group" "mgmt" {
  name        = "${var.environment}-mgmt-sg"
  description = "SG for Managment Subnet"
  vpc_id      = aws_vpc.main.id
  depends_on = [
    aws_vpc.main
  ]

    ingress {
    description = "Allow SSH from Stanford Network"
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = [var.stanford_cidr]
  }

    egress {
    description = "Allow outbound HTTPS"
    from_port = "443"
    to_port   = "443"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
    Name = var.mgmt_tier_name
  }
}
