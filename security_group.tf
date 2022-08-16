module "resoto_vpc_ssh_sg" {

  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "resoto_vpc/security_group"
  description = "Security group for ssh  within VPC"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [
    "${chomp(data.http.myip.body)}/32"
  ]
}
