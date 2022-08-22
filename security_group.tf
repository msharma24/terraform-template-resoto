module "resoto_vpc_ssh_sg" {

  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.11.0"

  name        = "resoto_vpc/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [
    "${chomp(data.http.myip.body)}/32"
  ]


}


resource "aws_security_group_rule" "allow_resh" {
  type              = "ingress"
  from_port         = 8900
  to_port           = 8900
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.resoto_vpc_ssh_sg.security_group_id
  description       = "Allow local shell access to resh"


}
