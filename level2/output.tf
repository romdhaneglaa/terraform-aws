output "dns_name" {
  value = aws_lb.lb_app.dns_name
}

output "publicIp" {
  value = aws_instance.public_instance.public_ip
}
