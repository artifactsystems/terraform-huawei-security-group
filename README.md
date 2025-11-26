# HuaweiCloud Security Group Terraform Module

Terraform module to easily, flexibly, and standardly create/manage Security Group (SG) resources and rules on Huawei Cloud.

## Features

This module supports the following Security Group features:

- ✅ Simple rule definitions (ingress/egress) by name and reference (`rules.tf`)
- ✅ Advanced rule types: `*_with_cidr_blocks`, `*_with_self`, `*_with_source_security_group_id`
- ✅ IPv4 and IPv6 support (for IPv6 use `ethertype = "IPv6"` and `cidr_blocks = "::/0"`)
- ✅ Computed ingress/egress rules for dynamic expansion
- ✅ Option to delete default rules (`delete_default_rules`)
- ✅ Tag management (`tags`, `security_group_tags`)
- ✅ Enterprise project integration (`enterprise_project_id`)
- ✅ Region selection (`region`)
- ✅ **Wrapper Feature:** This module can be used as a wrapper to orchestrate multiple security groups and rules in a higher-level composition, simplifying management for complex infrastructures.

## Examples

- [http](./examples/http) - Quick start for common ports (HTTP/HTTPS, SSH, etc.)
- [computed](./examples/computed) - Dynamic rule production using computed (dynamic) sources
- [ipv6](./examples/ipv6) - Rules for IPv6 with `ethertype = "IPv6"` and `::/0`
- [rules-only](./examples/rules-only) - Scenario for managing only rules

## Outputs

- `security_group_id` - ID of the created security group
- `security_group_name` - Name of the security group
- `security_group_description` - Description of the security group
- `security_group_rules` - List of rules on the SG
- `security_group_region` - The resource region
- `security_group_enterprise_project_id` - Enterprise Project ID

## Known Limitations / Roadmap

The following topics are planned for future improvement:

### Planned Features

- [ ] Wrapper composition enhancements (advanced orchestration, easier multiple group usage)
- [ ] Comprehensive example README files for each usage scenario
- [ ] Completion of all examples and improving variety/coverage of use cases
