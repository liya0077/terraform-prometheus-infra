output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "DNS name of the Prometheus ALB"
  value       = aws_lb.prometheus_alb.dns_name
}
