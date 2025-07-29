resource "aws_security_group" "lambda_sg" {
  name        = module.label_sg.name
  description = "Security group control traffic from ${module.label.name} Lambda function"
  vpc_id      = var.vpc_id
  tags        = module.label_sg.tags

  # Allow outbound HTTPS traffic to VPC endpoints and internet
  egress {
    description = "HTTPS outbound for AWS services"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound HTTP traffic
  egress {
    description = "HTTP outbound for external APIs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
