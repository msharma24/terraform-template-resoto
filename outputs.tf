output "ec2_public_ip" {
  value = "ssh ec2-user@${module.resoto_ec2_instance.public_ip}"


}

output "ec2_instance_Id" {
  value = module.resoto_ec2_instance.id

}

output "resoto_install_method" {
  value = local.resoto_install_method
}
