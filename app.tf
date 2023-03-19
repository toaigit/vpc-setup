# Default Security Group of VPC
resource "aws_security_group" "apps" {
  name        = "${var.environment}-application-sg"
  description = "SG for Application"
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

    ingress {
    description = "Allow SSH between servers"
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    self      = true
  }

    ingress {
    description = "Allow WebServers to AppServers"
    from_port = "6000"
    to_port   = "9000"
    protocol  = "tcp"
    security_groups = [aws_security_group.web.id]
  }

    egress {
    description = "Allow outbound HTTPS to Stanford"
    from_port = "443"
    to_port   = "443"
    protocol  = "tcp"
    cidr_blocks = [var.stanford_cidr]
  }

  tags = {
    Environment = "${var.environment}"
  }
}
