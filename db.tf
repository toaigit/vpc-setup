# Default Security Group of VPC
resource "aws_security_group" "db" {
  name        = "${var.environment}-database-sg"
  description = "SG for Database"
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
    description = "Allow Oracle to Stanford Network"
    from_port = "1521"
    to_port   = "1521"
    protocol  = "tcp"
    cidr_blocks = [var.stanford_cidr]
  }

    ingress {
    description = "Allow MySQL to Stanford Network"
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
    cidr_blocks = [var.stanford_cidr]
  }

    ingress {
    description = "Allow AppServers to DBServers"
    from_port = "1500"
    to_port   = "5000"
    protocol  = "tcp"
    security_groups = [aws_security_group.apps.id]
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
