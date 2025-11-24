output "security_group_id" {
  description = "The ID of the security group"
  value       = module.http_sg.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.http_sg.security_group_name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = module.http_sg.security_group_description
}

output "security_group_region" {
  description = "The region of the security group"
  value       = module.http_sg.security_group_region
}

output "security_group_enterprise_project_id" {
  description = "The enterprise project ID of the security group"
  value       = module.http_sg.security_group_enterprise_project_id
}

output "security_group_rules" {
  description = "The rules of the security group"
  value       = module.http_sg.security_group_rules
}
