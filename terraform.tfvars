############################################################
# Variables to be set for root module definitions
# 

# Access and secret keys of the AWS account to be used by Terraform
# If commented out, you will be prompted to specify them. 
#     For security reasons, it is the preferred method.
# Please, read https://www.linode.com/docs/applications/configuration-management/secrets-management-with-terraform/
#         for more information on secrets management, which is crucial.
aws_access_key            = "" 
aws_secret_key            = ""

# See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
# to get a list of all available regions.
# This one is located in Paris
aws_region                = "eu-west-3"

#
# End of variable to be set for root module definition
############################################################

############################################################
# Variables used in several modules creating Azure objects 
# 

# Prefix for all AWS objects
ObjNames-Prefix = "B13"

# Prefix for all AWS tags
Tags-Prefix = "B13"

#
# End of variables used in all modules creating Azure objects
############################################################

############################################################
# Variables to be set for TwoTiersVPC module definitions
# 

# The next variable contains the VPC main subnet using CIDR notation (16 bit subnetmask).
# Two sub-subnets (24 subnetmask) will be automatically created out of the parent one
VPC-IPv4-CIDR         = "10.13.0.0/16"

#
# End of variable to be set for TwoTiersVPC module definition
############################################################

############################################################
# Variables to be set for SecurityGroups module definitions
# 

#
# End of variable to be set for SecurityGroups module definition
############################################################

############################################################
# Variables to be set for EC2Instances module definitions
# 

# To get list of available images, "aws describe-images" command line can be used
# or connaect to AWS EC2 console and look for AMI's
# Owner of the image (AMI) to be installed in EC2instances
EC2-AmiOwners    = "099720109477" # Canonical
# Name of the image (AMI) to be installed in EC2instances
EC2-AmiName      = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
# EC2 virtualization type to be used
EC2-VirtType     = "hvm"
# EC2 instance type (size of the virtual machine)
EC2-InstanceType = "t2.micro"

# SSH public key to be autorized on remote machine
# On Ubuntu images by Canonical, the key will be authorized on default account named "ubuntu"
#EC2-SSHPubKey    = "ssh-rsa AAAAB3Nz..."
EC2-SSHPubKey   = "/some/path/.ssh/ubuntu_rsa.pub"

#
# End of variable to be set for EC2Instances module definition
############################################################

############################################################
# Variables to be set for EC2InstancesConfig module definitions
# 

# Agent ID (name of the SSH key) to be used by Ansible to connect to remote EC2 instances 
SSH-agent-ID          = "b13lab_rsa"
# Remote Linux account to be used by Ansible to connect to remote EC2 instances 
# On Ubuntu images by Canonical, the SSH key has been authorized on default account named "ubuntu"
SSH-username          = "ubuntu"

# Variable to run this module or not (true or false without quotes)
Ansible-NC-MariaDB-Enabled = true

# Directory where Ansible playbooks have been copied (cloned from GitHub)  
Ansible-PlayDir       = "/B13/SDI/ANSIBLE/SETUP"
# Ansible playbooks contain Ansible vaults to store sensitive information, like passwords
# To fully automatize the deployment of Nextcloud, the passphraseof the vaults can temporarily 
# be stored in a plaintext file. If the next variable is empty, the user will be prompted to enter 
# the passphrase. If set, the respective filename must contain the plaintext passphrase to be used 
Ansible-RedisVaultPwd = "/B13/SDI/ANSIBLE/SETUP/redisVault_pwd.txt"
Ansible-NCVaultPwd    = "/B13/SDI/ANSIBLE/SETUP/ncVault_pwd.txt"

# DNS name (FQDN) to be used to access the feshly installed Nextcloud instance.
# This variable is used to produce the Let's Encrypt certificate
# Either set an explicit FQDN
Nextcloud-FQDN        = "aws-nc1.byte13.org"
# or, in main.tf, use the FQDN returned by Terrafrom AWS provisionner (module.EC2Instances.PubIP1-FQDN)
# Version of Nextcloud to be installed
Nextcloud-Version     = "17.0.0"
# Directory which will store the Nextcloud data files
Nextcloud-DataDir     = "/var/NCDATA"

# Mail address to be used for notifications from Let's Encrypt 
Letsencrypt-email     = "tag@bluewin.ch"

#
# End of variable to be set for EC2InstancesConfig module definition
############################################################
