###############################################################
# Get ID of created Security Group
###############################################################
locals {
  create     = var.create
  this_sg_id = var.create_sg ? huaweicloud_networking_secgroup.this[0].id : var.security_group_id
}

###############################################################
# Security group
###############################################################
resource "huaweicloud_networking_secgroup" "this" {
  count = local.create && var.create_sg ? 1 : 0

  name                  = var.name
  description           = var.description
  region                = var.region
  enterprise_project_id = var.enterprise_project_id
  delete_default_rules  = var.delete_default_rules
  tags = merge(
    { Name = var.name },
    var.tags,
    var.security_group_tags
  )
}

###############################################################
# Ingress - List of rules (simple)
###############################################################
resource "huaweicloud_networking_secgroup_rule" "ingress_rules" {
  count = local.create ? length(var.ingress_rules) * length(var.ingress_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype         = "IPv4" # Simple rules are always IPv4, use ingress_with_cidr_blocks for IPv6
  description       = var.rules[var.ingress_rules[floor(count.index / length(var.ingress_cidr_blocks))]][3]

  protocol       = var.rules[var.ingress_rules[floor(count.index / length(var.ingress_cidr_blocks))]][2] == "" ? null : var.rules[var.ingress_rules[floor(count.index / length(var.ingress_cidr_blocks))]][2]
  port_range_min = var.rules[var.ingress_rules[floor(count.index / length(var.ingress_cidr_blocks))]][0]
  port_range_max = var.rules[var.ingress_rules[floor(count.index / length(var.ingress_cidr_blocks))]][1]

  remote_ip_prefix = var.ingress_cidr_blocks[count.index % length(var.ingress_cidr_blocks)]
}

###############################################################
# Ingress - Maps of rules
###############################################################
resource "huaweicloud_networking_secgroup_rule" "ingress_with_source_security_group_id" {
  count = local.create ? length(var.ingress_with_source_security_group_id) : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "ethertype",
    "IPv4",
  )

  remote_group_id = var.ingress_with_source_security_group_id[count.index]["source_security_group_id"]
  description = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "description",
    "Ingress Rule",
  )

  protocol = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
      )][2] == "" ? null : var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )

  port_range_min = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )

  port_range_max = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "ingress_with_cidr_blocks" {
  count = local.create ? length(var.ingress_with_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "ethertype",
    "IPv4",
  )

  remote_ip_prefix = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "cidr_blocks",
    join(",", var.ingress_cidr_blocks),
  )
  description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "ingress_with_self" {
  count = local.create ? length(var.ingress_with_self) : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype = lookup(
    var.ingress_with_self[count.index],
    "ethertype",
    "IPv4",
  )

  remote_group_id = local.this_sg_id

  description = lookup(
    var.ingress_with_self[count.index],
    "description",
    "Ingress Rule",
  )

  protocol = lookup(
    var.ingress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.ingress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.ingress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][1],
  )
}

###############################################################
# End of ingress
###############################################################

###############################################################
# Computed Ingress - List of rules (simple)
###############################################################
resource "huaweicloud_networking_secgroup_rule" "computed_ingress_rules" {
  count = local.create ? var.number_of_computed_ingress_rules : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype         = "IPv4"
  description       = var.rules[var.computed_ingress_rules[count.index]][3]

  protocol       = var.rules[var.computed_ingress_rules[count.index]][2] == "" ? null : var.rules[var.computed_ingress_rules[count.index]][2]
  port_range_min = var.rules[var.computed_ingress_rules[count.index]][0]
  port_range_max = var.rules[var.computed_ingress_rules[count.index]][1]

  remote_ip_prefix = element(
    var.computed_ingress_cidr_blocks,
    count.index,
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_ingress_with_source_security_group_id" {
  count = local.create ? var.number_of_computed_ingress_with_source_security_group_id : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype         = "IPv4"

  remote_group_id = var.computed_ingress_with_source_security_group_id[count.index]["source_security_group_id"]
  description = lookup(
    var.computed_ingress_with_source_security_group_id[count.index],
    "description",
    "Computed Ingress Rule",
  )

  protocol = lookup(
    var.computed_ingress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.computed_ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
      )][2] == "" ? null : var.rules[lookup(
      var.computed_ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )

  port_range_min = lookup(
    var.computed_ingress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.computed_ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )

  port_range_max = lookup(
    var.computed_ingress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.computed_ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_ingress_with_cidr_blocks" {
  count = local.create ? var.number_of_computed_ingress_with_cidr_blocks : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype         = "IPv4"

  remote_ip_prefix = lookup(
    var.computed_ingress_with_cidr_blocks[count.index],
    "cidr_blocks",
    join(",", var.computed_ingress_cidr_blocks),
  )
  description = lookup(
    var.computed_ingress_with_cidr_blocks[count.index],
    "description",
    "Computed Ingress Rule",
  )
  protocol = lookup(
    var.computed_ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.computed_ingress_with_cidr_blocks[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.computed_ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.computed_ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.computed_ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.computed_ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.computed_ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_ingress_with_self" {
  count = local.create ? var.number_of_computed_ingress_with_self : 0

  security_group_id = local.this_sg_id
  direction         = "ingress"
  ethertype         = "IPv4"

  remote_group_id = local.this_sg_id

  description = lookup(
    var.computed_ingress_with_self[count.index],
    "description",
    "Computed Ingress Rule",
  )

  protocol = lookup(
    var.computed_ingress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.computed_ingress_with_self[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.computed_ingress_with_self[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.computed_ingress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.computed_ingress_with_self[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.computed_ingress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.computed_ingress_with_self[count.index], "rule", "_")][1],
  )
}

###############################################################
# End of computed ingress
###############################################################

###############################################################
# Egress - List of rules (simple)
###############################################################
resource "huaweicloud_networking_secgroup_rule" "egress_rules" {
  count = local.create ? length(var.egress_rules) * length(var.egress_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype         = "IPv4"
  description       = var.rules[var.egress_rules[floor(count.index / length(var.egress_cidr_blocks))]][3]

  protocol         = var.rules[var.egress_rules[floor(count.index / length(var.egress_cidr_blocks))]][2] == "" ? null : var.rules[var.egress_rules[floor(count.index / length(var.egress_cidr_blocks))]][2]
  port_range_min   = var.rules[var.egress_rules[floor(count.index / length(var.egress_cidr_blocks))]][0]
  port_range_max   = var.rules[var.egress_rules[floor(count.index / length(var.egress_cidr_blocks))]][1]
  remote_ip_prefix = var.egress_cidr_blocks[count.index % length(var.egress_cidr_blocks)]
}

###############################################################
# Egress - Maps of rules
###############################################################
resource "huaweicloud_networking_secgroup_rule" "egress_with_source_security_group_id" {
  count = local.create ? length(var.egress_with_source_security_group_id) : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype = lookup(
    var.egress_with_source_security_group_id[count.index],
    "ethertype",
    "IPv4",
  )

  remote_group_id = var.egress_with_source_security_group_id[count.index]["source_security_group_id"]
  description = lookup(
    var.egress_with_source_security_group_id[count.index],
    "description",
    "Egress Rule",
  )

  protocol = lookup(
    var.egress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
      )][2] == "" ? null : var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )

  port_range_min = lookup(
    var.egress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )

  port_range_max = lookup(
    var.egress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "egress_with_cidr_blocks" {
  count = local.create ? length(var.egress_with_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype = lookup(
    var.egress_with_cidr_blocks[count.index],
    "ethertype",
    "IPv4",
  )

  remote_ip_prefix = lookup(
    var.egress_with_cidr_blocks[count.index],
    "cidr_blocks",
    join(",", var.egress_cidr_blocks),
  )
  description = lookup(
    var.egress_with_cidr_blocks[count.index],
    "description",
    "Egress Rule",
  )
  protocol = lookup(
    var.egress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.egress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.egress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "egress_with_self" {
  count = local.create ? length(var.egress_with_self) : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype = lookup(
    var.egress_with_self[count.index],
    "ethertype",
    "IPv4",
  )

  remote_group_id = local.this_sg_id
  description = lookup(
    var.egress_with_self[count.index],
    "description",
    "Egress Rule",
  )
  protocol = lookup(
    var.egress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.egress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.egress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][1],
  )
}

###############################################################
# End of egress
###############################################################

###############################################################
# Computed Egress - List of rules (simple)
###############################################################
resource "huaweicloud_networking_secgroup_rule" "computed_egress_rules" {
  count = local.create ? var.number_of_computed_egress_rules : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype         = "IPv4"
  description       = var.rules[var.computed_egress_rules[count.index]][3]

  protocol       = var.rules[var.computed_egress_rules[count.index]][2] == "" ? null : var.rules[var.computed_egress_rules[count.index]][2]
  port_range_min = var.rules[var.computed_egress_rules[count.index]][0]
  port_range_max = var.rules[var.computed_egress_rules[count.index]][1]

  remote_ip_prefix = element(
    var.computed_egress_cidr_blocks,
    count.index,
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_egress_with_source_security_group_id" {
  count = local.create ? var.number_of_computed_egress_with_source_security_group_id : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype         = "IPv4"

  remote_group_id = var.computed_egress_with_source_security_group_id[count.index]["source_security_group_id"]
  description = lookup(
    var.computed_egress_with_source_security_group_id[count.index],
    "description",
    "Computed Egress Rule",
  )

  protocol = lookup(
    var.computed_egress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.computed_egress_with_source_security_group_id[count.index],
      "rule",
      "_",
      )][2] == "" ? null : var.rules[lookup(
      var.computed_egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )

  port_range_min = lookup(
    var.computed_egress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.computed_egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )

  port_range_max = lookup(
    var.computed_egress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.computed_egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_egress_with_cidr_blocks" {
  count = local.create ? var.number_of_computed_egress_with_cidr_blocks : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype         = "IPv4"

  remote_ip_prefix = lookup(
    var.computed_egress_with_cidr_blocks[count.index],
    "cidr_blocks",
    join(",", var.computed_egress_cidr_blocks),
  )
  description = lookup(
    var.computed_egress_with_cidr_blocks[count.index],
    "description",
    "Computed Egress Rule",
  )
  protocol = lookup(
    var.computed_egress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.computed_egress_with_cidr_blocks[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.computed_egress_with_cidr_blocks[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.computed_egress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.computed_egress_with_cidr_blocks[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.computed_egress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.computed_egress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
}

resource "huaweicloud_networking_secgroup_rule" "computed_egress_with_self" {
  count = local.create ? var.number_of_computed_egress_with_self : 0

  security_group_id = local.this_sg_id
  direction         = "egress"
  ethertype         = "IPv4"

  remote_group_id = local.this_sg_id

  description = lookup(
    var.computed_egress_with_self[count.index],
    "description",
    "Computed Egress Rule",
  )

  protocol = lookup(
    var.computed_egress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.computed_egress_with_self[count.index], "rule", "_")][2] == "" ? null : var.rules[lookup(var.computed_egress_with_self[count.index], "rule", "_")][2],
  )

  port_range_min = lookup(
    var.computed_egress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.computed_egress_with_self[count.index], "rule", "_")][0],
  )

  port_range_max = lookup(
    var.computed_egress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.computed_egress_with_self[count.index], "rule", "_")][1],
  )
}

###############################################################
# End of computed egress
###############################################################