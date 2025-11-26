output "security_group_id" {
  description = "The ID of the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].id, "")
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].name, "")
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].description, "")
}

output "security_group_rules" {
  description = "The rules associated with the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].rules, [])
}

output "security_group_region" {
  description = "The region of the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].region, "")
}

output "security_group_enterprise_project_id" {
  description = "The enterprise project ID of the security group"
  value       = try(huaweicloud_networking_secgroup.this[0].enterprise_project_id, "")
}
