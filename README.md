# #terraform-template-resosto

## Description
This project creates an EC2 instance with an IAM Profile in an existing VPC with `resotoshell`  automatically configured  using Terraform

### But What is Resoto? 
#### Resoto indexes resources, captures dependencies, and maps out your infrastructure in an understandable graph. The graph contains metrics for each resource.


## Deployment
[Resoto](https://resoto.com/docs/getting-started/install-resoto) can be deployed using 3 methods - (1) using Docker and Docker compose (2) Install locally using python and pip package manager and (3) Installed on a kubernetes cluster. The Terraform configuration in this projects covers (1) and (2) to help kickstart the setup and of `resoto` on your AWS account(s) and experiment with resotoshell .


## How to deploy ? 
- Git clone this project.
- create a `terraform.tfvars` file locally `$touch terraform.tfvars` and enter the following values
```vpc_id                = "VPC_ID"
subnet_id             = "PUBLIC_SUBNET_ID"
public_key            = "YOUR_SSH_PUB_KEY"
#resoto_install_method = "docker" or "local"
```
`resoto_install_method` If you choose `docker` resoto shell will be configured to run inside docker containers using `docker-compose` and if you choose `local` the `resotoshell` will be configured to on the local VM using `python3.10` and `pip`



# Getting Started with Resoto
## Usage pattersns
