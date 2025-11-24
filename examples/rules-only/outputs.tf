
output "target_security_group_id" {
  description = "ID of the target Security Group (receiver for rules_one)"
  value       = huaweicloud_networking_secgroup.target.id
}

output "source_security_group_id" {
  description = "ID of the source Security Group (receiver for rules_two)"
  value       = huaweicloud_networking_secgroup.source.id
}

output "rules_one_rule_id" {
  description = "ID of the rule allowing HTTP from source to target"
  value       = try(module.rules_one.ingress_with_source_security_group_id_rule_ids, null)
}

output "rules_two_rule_id" {
  description = "ID of the rule allowing HTTP from target to source"
  value       = try(module.rules_two.ingress_with_source_security_group_id_rule_ids, null)
}
