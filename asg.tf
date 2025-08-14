# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu_22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch Template
resource "aws_launch_template" "prometheus_lt" {
  name_prefix   = "prometheus-lt-"
  image_id      = data.aws_ami.ubuntu_22.id
  instance_type = "t3.micro"
  key_name      = "Ansible" # Your existing key pair
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "prometheus-ec2"
      Project   = "prometheus"
      ManagedBy = "terraform"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "prometheus_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]

  launch_template {
    id      = aws_launch_template.prometheus_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.prometheus_tg.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "prometheus-ec2"
    propagate_at_launch = true
  }
  tag {
    key                 = "monitoring"
    value               = "true"
    propagate_at_launch = true
  }
}
