output "dns_name" {
  value = module.lb.dns_name
}

output "db_con" {
  value = module.rds.db_connexion
}
