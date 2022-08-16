variable "environment" {
  description = "AWS environment"
  default     = "dev"
  type        = string

}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"

}

variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string

}

variable "subnet_id" {
  description = "Public Subnet ID for Resoto Instance"
  type        = string

}

variable "public_key" {
  description = "SSH Public Key to create the EC2 Keypair"
  type        = string

}
