This directory is part of a set of modules for Terraform to build 
a VPC in AWS, made of 2 tiers subnets hosting a backend 
and a frontend Ubuntu servers. 

We leverage the following guide to build the infrastructure :
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html

IPv6 is implemented.

Both EC2 instances will be configured using Ansible playbooks to 
get a fully secured Nextcloud service.
The Ansible playbooks are available from the following GitHub repository :
        byte13/Ansible-Nextcloud-LetsEncrypt

Directory tree of Terraform modules :
.
├── main.tf
├── modules
│   ├── EC2Instances
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── EC2InstancesConfig
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── SecurityGroups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── README.txt
│   │   └── variables.tf
│   └── TwoTiersVPC
│       ├── main.tf
│       ├── outputs.tf
│       ├── README.txt
│       └── variables.tf
├── outputs.tf
├── README.txt
├── templates
│   ├── Backend-servers_inventory.tpl
│   └── Frontend-servers_inventory.tpl
├── terraform.tfvars
└── variables.tf

Please, read the REAMDE file in root module Directory for more information.
