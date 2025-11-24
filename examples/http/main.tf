provider "huaweicloud" {
  region = "ap-southeast-3"
}

########################################################
# HTTP SG
########################################################
module "http_sg" {
  source              = "../../"
  name                = "http-sg"
  description         = "Example security group that opens only HTTP (80/tcp) port to the world."
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

########################################################
# HTTP SG with ingress prefix list ids
########################################################
module "http_with_ingress_prefix_list_ids_sg" {
  source              = "../../"
  name                = "http-with-ingress-prefix-list-ids"
  description         = "Security group with HTTP open only to specified CIDR (similar to VPC internal traffic)."
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["10.0.0.0/16"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

########################################################
# HTTP SG with MySQL #1
########################################################
module "http_mysql_1_sg" {
  source              = "../../"
  name                = "http-mysql-1"
  description         = "Opens HTTP (80/tcp) and MySQL (3306/tcp) ports to the world."
  ingress_rules       = ["http-80-tcp", "mysql-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

########################################################
# HTTP SG with MySQL #2
########################################################
module "http_mysql_2_sg" {
  source              = "../../"
  name                = "http-mysql-2"
  description         = "Opens HTTP (80/tcp) and MySQL (3306/tcp) ports only to the specified CIDR."
  ingress_rules       = ["http-80-tcp", "mysql-tcp"]
  ingress_cidr_blocks = ["10.0.0.0/16"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

########################################################
# HTTP SG with egress minimal
########################################################
module "http_with_egress_minimal_sg" {
  source              = "../../"
  name                = "http-with-egress-minimal"
  description         = "Allows HTTP (80/tcp) only from specific CIDR; egress allows only HTTP port."
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["10.0.0.0/16"]
  egress_rules        = ["http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

########################################################
# HTTP SG with egress
########################################################
module "http_with_egress_sg" {
  source              = "../../"
  name                = "http-with-egress"
  description         = "HTTP and MySQL ports accessible only from specific CIDR, egress allowed to a small CIDR."
  ingress_rules       = ["http-80-tcp", "mysql-tcp"]
  ingress_cidr_blocks = ["10.0.0.0/16"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = ["10.10.10.0/28"]
}
