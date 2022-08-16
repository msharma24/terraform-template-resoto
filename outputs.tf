output "ec2_public_ip" {
  value = "ssh ec2-user@${module.resoto_ec2_instance.public_ip}"

}
