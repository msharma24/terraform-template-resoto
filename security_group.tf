module "resoto_vpc_ssh_sg" {

  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.11.0"

  name        = "resoto_vpc/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [
    "${chomp(data.http.myip.body)}/32"
  ]

  computed_ingress_with_cidr_blocks = [
    {
      from_port   = 8900
      to_port     = 8900
      protocol    = 6
      description = "Resotocore listens on port 8900"
      cidr_blocks = "${chomp(data.http.myip.body)}/32"
    },
  ]


}
