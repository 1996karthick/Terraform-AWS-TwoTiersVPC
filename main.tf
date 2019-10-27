# This block is used to connect to AWS API
# It is recommanded to keep secrets in environments variables 
# instead as in clear in the block in case the file is stored
# in some public source control system like Git.
# Varables syntax :
# $ export AWS_ACCESS_KEY_ID="<access key ID>"
# $ export AWS_SECRET_ACCESS_KEY="<secret access key>"
# $ export AWS_DEFAULT_REGION="<region>"

# or, even better, declare empty variables which will prompt the user at runtime
# unless he specifies the values as command line arguments using this 
# syntax : $ terraform apply -var 'access_key=<value>' -var 'secret_key=...'
# or she put the variables in a file and use this syntax : terraform apply -var-file <filename>.tfvars 
# Ensure respectively to clear your shell history or that the file is not uploaded in versioning tool like git 

# Configure the AWS Provider
provider "aws" {
  version    = "~> 2.22"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

# Configure the http Provider
provider "http" {
  version = "~> 1.1"
}

module "TwoTiersVPC" {
  source = "./modules/TwoTiersVPC"

  VPC-IPv4-CIDR = var.VPC-IPv4-CIDR

  ObjNames-Prefix  = var.ObjNames-Prefix
  Tags-Prefix      = var.Tags-Prefix

}

module "SecurityGroups" {
  source = "./modules/SecurityGroups"

  ObjNames-Prefix  = var.ObjNames-Prefix
  Tags-Prefix      = var.Tags-Prefix

  VPC-id       = module.TwoTiersVPC.VPC-id

  FrontSN-IPv4 = module.TwoTiersVPC.FrontSN-IPv4
  FrontSN-IPv6 = module.TwoTiersVPC.FrontSN-IPv6
}

module "EC2Instances" {
  source = "./modules/EC2Instances"

  ObjNames-Prefix  = var.ObjNames-Prefix
  Tags-Prefix      = var.Tags-Prefix

  EC2-AmiOwners    = var.EC2-AmiOwners
  EC2-AmiName      = var.EC2-AmiName
  EC2-VirtType     = var.EC2-VirtType
  EC2-InstanceType = var.EC2-InstanceType
  EC2-SSHPubKey    = var.EC2-SSHPubKey
  BackSN-id        = module.TwoTiersVPC.BackSN-id
  BackSG-id        = module.SecurityGroups.BackSG-id
  FrontSN-id       = module.TwoTiersVPC.FrontSN-id
  FrontSG-id       = module.SecurityGroups.FrontSG-id
}

module "EC2InstancesConfig" {
  source = "./modules/EC2InstancesConfig"

  Ansible-NC-MariaDB-Enabled = var.Ansible-NC-MariaDB-Enabled 

  SSH-agent-ID          = var.SSH-agent-ID
  SSH-username          = var.SSH-username

  Ansible-PlayDir       = var.Ansible-PlayDir
  Ansible-NCVaultPwd    = var.Ansible-NCVaultPwd
  Ansible-RedisVaultPwd = var.Ansible-RedisVaultPwd

  Nextcloud-FQDN        = var.Nextcloud-FQDN
  Nextcloud-Version     = var.Nextcloud-Version
  Nextcloud-DataDir     = var.Nextcloud-DataDir

  Letsencrypt-email     = var.Letsencrypt-email

  #  Nextcloud-FQDN           = "module.EC2Instances.EC2-FrontendSRV-PubFQDN"
  EC2-FrontendSRV-IPv6     = module.EC2Instances.EC2-FrontendSRV-IPv6
  EC2-FrontendSRV-PrivIPv4 = module.EC2Instances.EC2-FrontendSRV-PrivIPv4
  EC2-FrontendSRV-PrivFQDN = module.EC2Instances.EC2-FrontendSRV-PrivFQDN
  EC2-FrontendSRV-PubFQDN  = module.EC2Instances.EC2-FrontendSRV-PubFQDN
  EC2-BackendSRV-IPv6      = module.EC2Instances.EC2-BackendSRV-IPv6
  EC2-BackendSRV-PrivFQDN  = module.EC2Instances.EC2-BackendSRV-PrivFQDN
  EC2-BackendSRV-PubFQDN   = module.EC2Instances.EC2-BackendSRV-PubFQDN
  #  EC2-BackendSRV-PrivIPv4  = "module.EC2Instances.EC2-BackendSRV-PrivIPv4"

  # Next syntax not supported, yet, unfortunately.
  #  depends_on = [
  #    "module.TwoTiersVPC",
  #    "module.SecurityGroups"
  #  ]
}

