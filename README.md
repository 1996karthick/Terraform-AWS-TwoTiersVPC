# Terraform-AWS-TwoTiersVPC
This directory contains modules for Terraform to build 
a Virtual Private Cloud (VPC) in AWS, made of 2 tiers 
subnets hosting respectively a backend and a frontend Ubuntu server. 

We leverage the following guide to build the infrastructure :
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html

Both EC2 instances will then be configured using Ansible playbooks to get a fully secured Nextcloud service. 
You can prevent this step using *Ansible-NC-MariaDB-Enabled = false* in **terraform.tfvars**, in which case the process will end up with a fresh VPC made of 2 subnets (frontend and backend) with an EC2 instance each, running latest version of Ubuntu image by Canonical available in AWS.  

The current version doesn't use Elastic IP for Nextcloud service, but simple public IP's. As soon as the frontend is available, ensure its DNS fully qualified domain name (FQDN) is set in CNAME record of a valid FQDN from your domain (e.g. nextcloud.mydomain.com). \
The reason is that Let's Encrypt doesn't accept to create certificates for Amazon public FQDN's.

All steps described have been tested on Ubuntu 18.04-LTS running :
- Terraform 0.12.12
- Ansible 2.8.5
- Python 2.7.15+ 

Prerequisits to deploy the infrastructure and install a secured Nextcloud :
a. Create an account in AWS and get respective API keys to be used with Terraform 
b. [Install Terraform](https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu#983352) and ensure it is in your $PATH \
c. [Install Ansible](https://linuxhandbook.com/install-ansible-linux/) and ensure it is in your $PATH \
d. Clone [byte13/Terraform-AWS-TwoTiersVPC](https://github.com/byte13/Terraform-AWS-TwoTiersVPC) locally \
e. Clone [byte13/Ansible-MariaDB-Redis-Nextcloud-LetsEncrypt](https://github.com/byte13/Ansible-MariaDB-Redis-Nextcloud-LetsEncrypt) locally \
f. Create SSH keys to be used later on to execute Ansible playbooksi, and protect the private key with a strong passphrase. \
g. Use ssh-agent and ssh-add to unlock aforementioned SSH key so that Ansible playbook will run without prompting you for the passphrase. \
h. **Read all comments and set the variables for your environment in terraform.tfvars**. This file is located in the root module directory of Terraform definitions cloned previously (step d.)\
i. **Read all comments and follow instructions in README file of the Ansible playbook** \
j. Change working directory into root module of Terraform definitions cloned previously (step d.) \
k. Run the following commands

```
$ terraform init
$ terraform plan
$ terraform apply
```

## Directory tree

```
.
├── .gitignore
├── main.tf
├── modules
│   ├── EC2Instances
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── README.txt
│   │   └── variables.tf
│   ├── EC2InstancesConfig
│   │   ├── main.tf
│   │   ├── README.txt
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
├── README.md
├── templates
│   ├── Backend-servers_inventory.tpl
│   └── Frontend-servers_inventory.tpl
├── terraform.tfvars
├── variables.tf
└── versions.tf
```

## Here are the main steps performed by these Terraform modules :

**Root module** 
Triggs the modules described below then displays usefull information about the created AWS objects.

**Module TwoTiersVPC builds subnets, NAT and routing**

 1. Create VPC using ${var.VPC-IPv4-CIDR} range specified in terraform.tfvars 
 2. Create frontend subnet using a subnet of ${var.VPC-IPv4-CIDR} 
 3. Create backend subnet using a subnet of ${var.VPC-IPv4-CIDR}
 4. Create the Internet Gateway (IPv4 and IPv6) for the VPC
 5. Possibly create an Elastic IP for NAT gateway (optional if NAT gateway is created with Terraform)
 6. Create a NAT Gateway to let pivate IP addresses (RFC1918) to communicate to/from Interne 
 7. Create IPv6 egress, only, gateway for the VPC in case backend subnet should not be reachable from Internet 
 8. Setup IP routing

**Module SecurityGroups prepares security goups to filter network trafics to/from EC2 instances**

 9. Get local IP address (of the machine executing Terrafom) and subnet to be allowed in security groups rules.
10. Create Security Group for frontend subnet
    - Frontend port 80/TCP (HTTPS) reachable from all Internet.
    - Frontend port 443/TCP (HTTPS) reachable from all Internet.
    - Frontend port 22/TCP (SSH) reachable from the host currently running Terraform, only 
11. Create Security Group for backend subnet
    - Frontend to backend port 3306/TCP (Nextcloud to MySQL)
    - Backend port 22/TCP (SSH) reachable over IPv6 from the host currently running Terraform, only 

**Module EC2Instances creates the instances from latest Ubuntu images by Canonical**

12. Create backend server and authorize our SSH public key
    - Assign respective security group
13. Perform some SysAdmin tasks on the backend VM (over SSH)
14. Update Ansible inventory file with backend server information
15. Create frontend server and authorize our SSH public key
    - Assign respective security group
16. Perform some SysAdmin tasks on the frontend VM
17. Create an Elastic IP for Nextcloud service
    - Still to be done. Currently using public (dynamic) IP.
    - Interesting description of Eslastic IP's and Public IP's : \
                [difference-between-elastic-ip-and-public-ip](https://kerneltalks.com/cloud-services/difference-between-elastic-ip-and-public-ip/) \
                Basically, Public IP changes each time the instance is restarted (dynamic IP) \
                Elastic IP is static and keeps assigned (and charged) while the instance is down.
18. Update Ansible inventory file with frontend server information

**Module EC2InstancesConfig runs the Ansible playbooks**

19. Install and configure Apache, PHP, MariaDB, Redis, Nextcloud and Let'Encrypt
20. Delete Ansible inventories
21. Possibly, disable direct access to backend subnet
    - To be re-enabled each time configuration changes must be applied on backend instances
