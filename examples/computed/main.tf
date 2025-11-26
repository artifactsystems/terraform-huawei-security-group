provider "huaweicloud" {
  region = "tr-west-1" # Change to your region
}

###########################
# Security groups examples
###########################

# First security group - HTTP/HTTPS
module "http_sg" {
  source = "../../"

  name        = "computed-http-sg"
  description = "Security group with HTTP/HTTPS ports open"

  # Regular HTTP rule
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # HTTPS with specific CIDR (demonstrating regular rules)
  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = "10.0.0.0/8"
      description = "HTTPS from internal network"
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "test"
    Type        = "http"
  }
}

# Second security group - MySQL with computed rules
# This demonstrates the power of computed rules:
# The MySQL SG references the HTTP SG's ID which is only known after HTTP SG is created
module "mysql_sg" {
  source = "../../"

  name        = "computed-mysql-sg"
  description = "Security group with MySQL port open for HTTP SG (computed)"

  # Computed rule: MySQL access from HTTP security group
  # This is "computed" because http_sg.security_group_id is not known until apply time
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.http_sg.security_group_id
      description              = "MySQL from HTTP SG"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  # Also allow MySQL from specific CIDR using regular (non-computed) rule
  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = "192.168.0.0/16"
      description = "MySQL from management network"
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "test"
    Type        = "database"
  }
}

# Third security group - Redis with multiple computed rules
module "redis_sg" {
  source = "../../"

  name        = "computed-redis-sg"
  description = "Security group with Redis port open for both HTTP and MySQL SGs (computed)"

  # Multiple computed rules from different security groups
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.http_sg.security_group_id
      description              = "Redis from HTTP SG"
    },
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.mysql_sg.security_group_id
      description              = "Redis from MySQL SG"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "test"
    Type        = "cache"
  }
}

# Fourth security group - Using computed rules with dynamic CIDRs
locals {
  # Simulating dynamically computed CIDR blocks
  # In real world, these might come from data sources or other modules
  app_cidrs = ["10.1.0.0/16", "10.2.0.0/16"]
}

module "app_sg" {
  source = "../../"

  name        = "computed-app-sg"
  description = "Security group with computed ingress rules from dynamic CIDRs"

  # Using computed_ingress_rules with dynamic CIDR blocks
  computed_ingress_rules           = ["ssh-tcp", "ssh-tcp"] # One rule per CIDR
  computed_ingress_cidr_blocks     = local.app_cidrs
  number_of_computed_ingress_rules = length(local.app_cidrs)

  # Computed self-referencing rule
  computed_ingress_with_self = [
    {
      rule        = "all-tcp"
      description = "Allow all TCP within same SG"
    }
  ]
  number_of_computed_ingress_with_self = 1

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "test"
    Type        = "application"
  }
}
