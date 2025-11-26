provider "huaweicloud" {
  region = "tr-west-1"
}

########################################################
# HTTP SG
########################################################
module "http_sg" {
  source      = "../../"
  name        = "http-sg"
  description = "Example security group that opens only HTTP (80/tcp) port to the world."
  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "::/0"
      ethertype   = "IPv6"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "::/0"
      ethertype   = "IPv6"
    }
  ]
}
