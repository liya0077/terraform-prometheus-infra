resource "aws_instance" "bastion" {
  ami           = "ami-08c40ec9ead489470"  # Ubuntu Server 22.04 LTS in us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_az1.id
  key_name      = "Ansible"  # Make sure this key exists in your local ~/.ssh/

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name       = "prometheus-bastion"
    Project    = "prometheus"
    Monitoring = "false"
    Role       = "Bastion"   # <-- Added this tag for dynamic Ansible
  }
}
