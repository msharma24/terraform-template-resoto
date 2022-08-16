data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


# lookup latest AL2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm*"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
  request_headers = {
    Accept = "application/text"
  }
}

#------------------------------------------------------------------
#  Generates Rnadom String
#------------------------------------------------------------------
resource "random_id" "random_id" {
  byte_length = 5

}
