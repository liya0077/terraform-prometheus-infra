# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_az1.id

  tags = merge(local.common_tags, {
    Name = "${local.name_tag_prefix}nat-gateway"
  })

  depends_on = [aws_internet_gateway.igw]
}
