module "resoto_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"

  name = "${var.environment}/resoto_instance"

  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.xlarge"
  monitoring                  = true
  vpc_security_group_ids      = [module.resoto_vpc_ssh_sg.security_group_id]
  iam_instance_profile        = module.resoto_instance_iam_assumable_role.iam_instance_profile_id
  associate_public_ip_address = true
  key_name                    = module.key_pair.key_pair_name

  #user_data_base64 = base64encode(local.user_data)
  # user_data_base64 = var.resoto_install_method == "docker" ? base64encode(local.user_data_docker) : base64encode(local.user_data_python_pip)
  user_data = local.resoto_install_method == "docker" ? local.user_data_docker : local.user_data_python_pip

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

locals {
  resoto_install_method = var.resoto_install_method
}


module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "${var.environment}-build-instance${random_id.random_id.hex}"
  public_key = var.public_key

}
