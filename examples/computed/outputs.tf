output "http_sg_id" {
  description = "The ID of the HTTP security group"
  value       = module.http_sg.security_group_id
}

output "http_sg_name" {
  description = "The name of the HTTP security group"
  value       = module.http_sg.security_group_name
}

output "mysql_sg_id" {
  description = "The ID of the MySQL security group"
  value       = module.mysql_sg.security_group_id
}

output "mysql_sg_name" {
  description = "The name of the MySQL security group"
  value       = module.mysql_sg.security_group_name
}

output "redis_sg_id" {
  description = "The ID of the Redis security group"
  value       = module.redis_sg.security_group_id
}

output "redis_sg_name" {
  description = "The name of the Redis security group"
  value       = module.redis_sg.security_group_name
}

output "app_sg_id" {
  description = "The ID of the App security group"
  value       = module.app_sg.security_group_id
}

output "app_sg_name" {
  description = "The name of the App security group"
  value       = module.app_sg.security_group_name
}