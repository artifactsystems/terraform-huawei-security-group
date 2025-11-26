provider "huaweicloud" {
  region = "tr-west-1"
}

########################################################
# Create SGs
########################################################

resource "huaweicloud_networking_secgroup" "target" {
  name        = "rules-only-target-sg"
  description = "Target Security Group for HTTP ingress rule"
}

resource "huaweicloud_networking_secgroup" "source" {
  name        = "rules-only-source-sg"
  description = "Source Security Group allowed for HTTP ingress"
}

########################################################
# Add SG rules
########################################################

module "rules_one" {
  source = "../../"

  create_sg         = false
  security_group_id = huaweicloud_networking_secgroup.target.id

  ingress_with_source_security_group_id = [
    {
      description              = "Allow HTTP from source to target SG"
      rule                     = "http-80-tcp"
      source_security_group_id = huaweicloud_networking_secgroup.source.id
    }
  ]
}

module "rules_two" {
  source = "../../"

  create_sg         = false
  security_group_id = huaweicloud_networking_secgroup.source.id
  ingress_with_source_security_group_id = [
    {
      description              = "Allow HTTP from target to source SG"
      rule                     = "http-80-tcp"
      source_security_group_id = huaweicloud_networking_secgroup.target.id
    }
  ]
}
