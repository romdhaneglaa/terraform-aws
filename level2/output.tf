#output "public_ip" {
#  value = aws_instance.public.public_ip
#}

output "private_ip" {
  value = aws_instance.private[*].private_ip
}
output "dns_name" {
  value = aws_lb.lb_app.dns_name
}

