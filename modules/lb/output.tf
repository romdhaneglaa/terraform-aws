output "dns_name" {
  value = aws_lb.lb_app.dns_name
}
output "target_group_arns" {
  value = aws_alb_target_group.group.arn
}
output "lb_security_groups" {
  value = aws_security_group.lb_sec_gpe.id
}
