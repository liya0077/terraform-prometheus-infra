
# Bastion Host SG
resource "aws_security_group" "bastion_sg" {
  name        = "prometheus-bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "prometheus - bastion-sg"
    Project = "prometheus"
  }
}

# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "prometheus-alb-sg"
  description = "Allow HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "prometheus - alb-sg"
    Project = "prometheus"
  }
}

# EC2 (Prometheus) SG
resource "aws_security_group" "ec2_sg" {
  name        = "prometheus-ec2-sg"
  description = "Allow Prometheus from ALB and SSH from Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description              = "Prometheus from ALB"
    from_port                = 9090
    to_port                  = 9090
    protocol                 = "tcp"
    security_groups          = [aws_security_group.alb_sg.id]
  }

  ingress {
    description              = "SSH from Bastion"
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    security_groups          = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "prometheus - ec2-sg"
    Project = "prometheus"
  }
}
