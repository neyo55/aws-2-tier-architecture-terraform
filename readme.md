# Two-Tier Architecture Deployment with Terraform

This project will create a highily available web application infrastructure using a two-tier architecture on Amazon Web Services (AWS). The architecture comprises a web tier that handles user requests and a database tier for data storage. I used Terraform for Infrastructure as Code (IaC) to provision and manage AWS resources efficiently.


## Table of Contents

- [Two-Tier Architecture Deployment with Terraform](#two-tier-architecture-deployment-with-terraform)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Architectural Diagram](#architectural-diagram)
  - [Key Features](#key-features)
  - [Prerequisites](#prerequisites)
  - [Configuration Overview](#configuration-overview)
    - [Provider configuration](#provider-configuration)
    - [Terraform Block:](#terraform-block)
    - [Provider Block:](#provider-block)
    - [Network Configuration](#network-configuration)
    - [Variables File](#variables-file)
      - [In `variables.tf`:](#in-variablestf)
        - [In `compute/variables.tf`:](#in-computevariablestf)
        - [In `alb/variables.tf`:](#in-albvariablestf)
        - [In `database/variables.tf`:](#in-databasevariablestf)
    - [Security group](#security-group)
      - [Instance Security Group:](#instance-security-group)
      - [Database Security Group:](#database-security-group)
      - [Load Balancer Security Group:](#load-balancer-security-group)
    - [Compute Resources](#compute-resources)
    - [Database Configuration](#database-configuration)
    - [Load Balancer Setup](#load-balancer-setup)
    - [Output File](#output-file)
  - [Additional step](#additional-step)
      - [MySQL Table Creation Script:](#mysql-table-creation-script)
      - [Store Text File Contents in Database:](#store-text-file-contents-in-database)
  - [tfvars file](#tfvars-file)
      - [Network Configuration:](#network-configuration-1)
      - [Compute, Database, Security Groups, Application Load Balancer (ALB):](#compute-database-security-groups-application-load-balancer-alb)
  - [Usage](#usage)
  - [After successful deployment](#after-successful-deployment)
  - [Cleanup](#cleanup)
  - [Security Considerations](#security-considerations)
  - [References](#references)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

This Terraform configuration automates the deployment of a two-tier architecture on AWS, facilitating the creation of a scalable and resilient web application environment. The architecture is structured to separate the presentation layer (web servers) from the data layer (database), enhancing maintainability, scalability, and security.

## Architectural Diagram 

![architectural-diagram](./two%20tier%20diagram.png "architectural-diagram")

## Key Features

- **Infrastructure as Code (IaC):** Leveraging Terraform for defining and provisioning the entire infrastructure, ensuring consistency and repeatability.
- **High Availability:** Utilized multiple Availability Zones (AZs), the application is designed for high availability, minimizing downtime in case of failures.
- **Security:** Implementing security best practices, such as network ACLs, security groups, and encryption, to protect data and resources.
- **Database Management:** A managed database service  Amazon RDS is used to store and manage application data, providing reliability and data durability.
- **Load Balancing:** Employing Elastic Load Balancers (ELBs) to distribute incoming traffic across multiple web servers, optimizing resource utilization.

## Prerequisites

Before using this Terraform configuration, ensure you have the following prerequisites:

- **AWS Account**: You must have an AWS account with appropriate permissions to create and manage resources.
- **Terraform Installation**: Terraform must be installed on your local machine. You can download Terraform from [here](https://www.terraform.io/downloads.html) and follow the installation instructions.
- Familiarity with Terraform and infrastructure as code principles.<br>
- An IDE (VS Code Editor) .<br>

## Configuration Overview

The Terraform configuration is organized into several files and directories, each responsible for provisioning specific components of the two-tier architecture.
### Provider configuration

Let's break down the Terraform code in `provider.tf`:

### Terraform Block:

1. **Terraform Block**:
   - Description: The `terraform` block defines the required providers for the Terraform configuration. It specifies that this configuration requires the AWS provider from HashiCorp.

   ```hcl
   terraform {
     required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "~> 5.0"
       }
     }
   }
   ```

   - This block ensures that the AWS provider is available and at least version 5.0 or higher is used.

### Provider Block:

2. **AWS Provider Block**:
   - Description: The `provider` block configures the AWS provider. It specifies the region where resources will be provisioned and the AWS profile to use for authentication.

   ```hcl
   provider "aws" {
     region  = var.region
     profile = "developer"
   }
   ```

   - `region`: Specifies the AWS region where resources will be created. It is set dynamically using the value of the `region` variable.
   - `profile`: Specifies the AWS profile to use for authentication. In this case, it's set to "developer".

By configuring the provider in this way, Terraform will use the AWS provider from HashiCorp, ensure it meets the required version, and use the specified region and profile for resource provisioning and authentication, respectively.


### Network Configuration

- **`vpc.tf`**: This file defines the Virtual Private Cloud (VPC), subnets, internet gateway, and route tables. It ensures network isolation and sets up the routing infrastructure for the architecture.
  
Let's explain each output defined in the `vpc.tf` file:

1. **AWS VPC (Virtual Private Cloud)**:
   - Resource Type: `aws_vpc`
   - Description: Creates a Virtual Private Cloud (VPC) in AWS, which allows you to provision a logically isolated section of the AWS Cloud where you can launch AWS resources.
   - Attributes:
     - `cidr_block`: The CIDR block for the VPC, defining its IP address range.
     - `tags`: Tags applied to the VPC for identification and organization.

2. **AWS Subnets**:
   - Resource Types: `aws_subnet`
   - Description: Creates subnets within the VPC to divide the IP address space and isolate resources.
   - Attributes:
     - `vpc_id`: The ID of the VPC in which the subnet will be created.
     - `cidr_block`: The CIDR block for the subnet, defining its IP address range.
     - `availability_zone`: The availability zone in which the subnet will be created.
     - `map_public_ip_on_launch`: Specifies whether instances launched in the subnet should be assigned public IP addresses automatically.
     - `tags`: Tags applied to the subnet for identification and organization.

3. **AWS Internet Gateway**:
   - Resource Type: `aws_internet_gateway`
   - Description: Creates an internet gateway, which allows communication between instances in your VPC and the internet.
   - Attributes:
     - `vpc_id`: The ID of the VPC to which the internet gateway will be attached.
     - `tags`: Tags applied to the internet gateway for identification and organization.

4. **AWS Route Table**:
   - Resource Type: `aws_route_table`
   - Description: Creates a route table, which specifies how network traffic is directed within the VPC.
   - Attributes:
     - `vpc_id`: The ID of the VPC to which the route table will be associated.
     - `route`: Defines a route in the route table, specifying the destination CIDR block and the target (in this case, an internet gateway).
     - `tags`: Tags applied to the route table for identification and organization.

5. **Route Table Associations**:
   - Resource Types: `aws_route_table_association`
   - Description: Associates the public subnets with the route table to define the routing for traffic leaving the subnets.
   - Attributes:
     - `subnet_id`: The ID of the subnet to associate with the route table.
     - `route_table_id`: The ID of the route table to which the subnet will be associated.

These resources collectively define the networking infrastructure for the two-tier architecture, including VPC, subnets, internet gateway, and route tables, enabling communication between resources within the VPC and with the internet.  

### Variables File

- **`variables.tf`**: Contains variable definitions used throughout the configuration, such as VPC CIDR block, subnet CIDR blocks, availability zones, internet gatway, route table, route table association, keypair, ec2, alb and database.

Let's break down each variable definition provided in the Terraform files:

#### In `variables.tf`:

1. **Region Variable**:
   - Name: `region`
   - Description: Specifies the AWS region where the infrastructure will be deployed.

2. **Project Name Variable**:
   - Name: `project_name`
   - Description: Defines the name of the project or application being deployed. This name is often used as a prefix for resource names to ensure uniqueness.

3. **VPC CIDR Block Variable**:
   - Name: `vpc_cidr_block`
   - Description: Specifies the CIDR block for the Virtual Private Cloud (VPC) that will be created. This CIDR block defines the IP address range for the VPC.

4. **Public Subnet 1 CIDR Block Variable**:
   - Name: `public_subnet_1_cidr_block`
   - Description: Defines the CIDR block for the first public subnet within the VPC.

5. **Public Subnet 2 CIDR Block Variable**:
   - Name: `public_subnet_2_cidr_block`
   - Description: Defines the CIDR block for the second public subnet within the VPC.

6. **Private Subnet 1 CIDR Block Variable**:
   - Name: `private_subnet_1_cidr_block`
   - Description: Specifies the CIDR block for the first private subnet within the VPC.

7. **Private Subnet 2 CIDR Block Variable**:
   - Name: `private_subnet_2_cidr_block`
   - Description: Specifies the CIDR block for the second private subnet within the VPC.

8. **Public Subnet 1 Availability Zone Variable**:
   - Name: `public_subnet_1_az`
   - Description: Specifies the availability zone for the first public subnet.

9. **Public Subnet 2 Availability Zone Variable**:
   - Name: `public_subnet_2_az`
   - Description: Specifies the availability zone for the second public subnet.

10. **Private Subnet 1 Availability Zone Variable**:
    - Name: `private_subnet_1_az`
    - Description: Specifies the availability zone for the first private subnet.

11. **Private Subnet 2 Availability Zone Variable**:
    - Name: `private_subnet_2_az`
    - Description: Specifies the availability zone for the second private subnet.

##### In `compute/variables.tf`:

12. **Security Group Name Variable**:
    - Name: `sg-name`
    - Description: Defines the name for the security group that will be associated with the EC2 instances.

13. **Instance Type Variable**:
    - Name: `instance_type`
    - Description: Specifies the instance type for the EC2 instances, determining their compute capacity.

14. **Key Pair Name Variable**:
    - Name: `keypair_name`
    - Description: Specifies the name of the key pair used for SSH access to the EC2 instances.

##### In `alb/variables.tf`:

15. **Load Balancer Security Group Name Variable**:
    - Name: `lb_sg_name`
    - Description: Defines the name for the security group associated with the Application Load Balancer (ALB).

16. **Target Group Name Variable**:
    - Name: `tg_name`
    - Description: Specifies the name for the target group associated with the ALB.

17. **Load Balancer Name Variable**:
    - Name: `lb_name`
    - Description: Specifies the name for the Application Load Balancer (ALB).

##### In `database/variables.tf`:

18. **Database Security Group Name Variable**:
    - Name: `db_sg_name`
    - Description: Defines the name for the security group associated with the database instance.

19. **Database Subnet Group Name Variable**:
    - Name: `db_subnet_group_name`
    - Description: Specifies the name for the subnet group associated with the database instance.

20. **Database Username Variable**:
    - Name: `db_username`
    - Description: Specifies the username used to authenticate connections to the database.

21. **Database Password Variable**:
    - Name: `db_password`
    - Description: Specifies the password used to authenticate connections to the database.

These variables provide flexibility and customization options when deploying infrastructure using Terraform, allowing users to tailor the configuration to their specific requirements.

### Security group 

Let's break down the Terraform code in `security-groups.tf`:

#### Instance Security Group:

1. **AWS Security Group for Instances**:
   - Description: This resource defines a security group for instances, allowing inbound traffic for SSH (port 22), HTTP (port 80), and ICMP. It also allows all outbound traffic.
   
   ```hcl
   resource "aws_security_group" "my_sg" {
     name        = var.sg-name
     description = "Allow inbound tls traffic"
     vpc_id      = aws_vpc.my_vpc.id

     ingress {
       description = "SSH from VPC"
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     // Other ingress rules for HTTP and ICMP

     egress {
       description      = "All traffic"
       from_port        = 0
       to_port          = 0
       protocol         = "-1"
       cidr_blocks      = ["0.0.0.0/0"]
       ipv6_cidr_blocks = ["::/0"]
     }

     tags = {
       Name = "${var.project_name}_security_group"
     }
   }
   ```

#### Database Security Group:

2. **AWS Security Group for Database**:
   - Description: This resource defines a security group for the database, allowing inbound traffic on port 3306 (MySQL) from the instance security group (`my_sg`). It also allows all outbound traffic.
   
   ```hcl
   resource "aws_security_group" "db_sg" {
     name        = var.db_sg_name
     description = "Allow inbound TLS from my_sg"
     vpc_id      = aws_vpc.my_vpc.id

     ingress {
       from_port       = 3306
       to_port         = 3306
       protocol        = "tcp"
       security_groups = [aws_security_group.my_sg.id]
     }

     // Egress rule to allow outbound traffic

     tags = {
       Name = "${var.project_name}_db_sg"
     }
   }
   ```

#### Load Balancer Security Group:

3. **AWS Security Group for Load Balancer**:
   - Description: This resource defines a security group for the load balancer, allowing inbound traffic on port 80 (HTTP). It allows all outbound traffic.
   
   ```hcl
   resource "aws_security_group" "lb_sg" {
     name        = var.lb_sg_name
     description = "Allow inbound TLS traffic for the load balancer"
     vpc_id      = aws_vpc.my_vpc.id

     ingress {
       description = "HTTP from VPC"
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }

     // Egress rule to allow outbound traffic

     tags = {
       Name = "${var.project_name}_lb_sg"
     }
   }
   ```

By defining these security groups, the Terraform configuration ensures that the instances, database, and load balancer have the necessary network access permissions based on their respective roles within the infrastructure.

### Compute Resources

- **`compute/ec2.tf`**: Defines the EC2 instances that serve as web servers. It specifies the instance type, key pair, and user data script for provisioning the Apache HTTP Server.

Let's explain each output defined in the `ec2.tf` file:

1. **AWS Key Pair**:
   - Resource Type: `aws_key_pair`
   - Description: Creates an SSH key pair to securely connect to EC2 instances launched in the AWS account.
   - Attributes:
     - `key_name`: The name of the SSH key pair.
     - `public_key`: The public key generated from a TLS private key.

2. **TLS Private Key**:
   - Resource Type: `tls_private_key`
   - Description: Generates a TLS private key used for SSH key pair generation.
   - Attributes:
     - `algorithm`: The algorithm used for key generation (RSA in this case).
     - `rsa_bits`: The number of bits for RSA key generation (4096 bits in this case).

3. **Local File**:
   - Resource Type: `local_file`
   - Description: Writes the private key to a local file on the machine where Terraform is being executed.
   - Attributes:
     - `content`: The content of the private key in PEM format.
     - `filename`: The path and filename where the private key file will be saved.

4. **AWS AMI Data Source**:
   - Resource Type: `data.aws_ami`
   - Description: Retrieves information about the latest Ubuntu AMI (Amazon Machine Image) provided by Canonical.
   - Attributes:
     - `most_recent`: Specifies to retrieve the most recent AMI.
     - `owners`: The AWS account ID of the AMI owner (Canonical in this case).
     - `filter`: Filters to narrow down the search for the desired AMI based on name and virtualization type.

5. **AWS EC2 Instances**:
   - Resource Type: `aws_instance`
   - Description: Launches EC2 instances in the specified subnets with the specified configuration.
   - Attributes:
     - `ami`: The ID of the AMI used to launch the instance.
     - `instance_type`: The instance type specifying the compute, memory, and networking capacity of the instance.
     - `subnet_id`: The ID of the subnet in which the instance will be launched.
     - `key_name`: The name of the SSH key pair used to connect to the instance.
     - `security_groups`: The security group(s) associated with the instance to control inbound and outbound traffic.
     - `depends_on`: Specifies dependencies that must be satisfied before creating the instance (in this case, the SSH key pair).
     - `user_data`: Base64-encoded user data script to run when the instance starts.
     - `tags`: Tags applied to the instance for identification and organization.

These resources collectively define the EC2 instances and associated resources required for the two-tier architecture, including SSH key pair, private key generation, AMI retrieval, and instance creation.

- **`ec2/user-data.sh`**: Contains a bash script executed on EC2 instances during initialization. It installs and configures Apache HTTP Server to serve web content.

### Database Configuration

- **`database/db-main.tf`**: Configures the RDS database instance, including parameters like engine version, instance class, username, and password. It also creates a subnet group for the database to ensure high availability and fault tolerance.

Let's explain each resource defined in the `db-main.tf` file:

1. **AWS RDS Database Instance**:
   - Resource Type: `aws_db_instance`
   - Description: Creates a relational database service (RDS) instance in the AWS account.
   - Attributes:
     - `allocated_storage`: The amount of storage allocated for the database in GB.
     - `db_name`: The name of the database to be created within the instance.
     - `engine`: The type of database engine to be used (MySQL in this case).
     - `engine_version`: The version of the database engine to be used (MySQL 5.7).
     - `instance_class`: The instance type for the RDS instance.
     - `username`: The username for accessing the database.
     - `password`: The password for accessing the database.
     - `parameter_group_name`: The name of the parameter group for the database engine.
     - `db_subnet_group_name`: The name of the subnet group for the database, specifying the subnets in which the RDS instance is placed.
     - `vpc_security_group_ids`: The security group(s) associated with the RDS instance to control inbound and outbound traffic.
     - `skip_final_snapshot`: Specifies whether to skip creating a final DB snapshot when the DB instance is deleted.

2. **AWS RDS Subnet Group**:
   - Resource Type: `aws_db_subnet_group`
   - Description: Creates a subnet group for the RDS instance, specifying the subnets where the RDS instance will be placed.
   - Attributes:
     - `name`: The name of the subnet group.
     - `subnet_ids`: The list of subnet IDs that belong to the subnet group.
     - `tags`: Tags applied to the subnet group for identification and organization.

These resources collectively define the AWS RDS database instance and its associated subnet group required for the two-tier architecture.

### Load Balancer Setup

- **`alb/alb.tf`**: Sets up the Application Load Balancer (ALB) to distribute incoming web traffic across multiple EC2 instances. It configures listeners, target groups, and security groups for the ALB.

Let's explain each resource defined in the `alb.tf` file:

1. **AWS Application Load Balancer (ALB)**:
   - Resource Type: `aws_lb`
   - Description: Creates an application load balancer in the specified subnets to distribute incoming application traffic across multiple targets.
   - Attributes:
     - `name`: The name of the load balancer.
     - `internal`: Specifies whether the load balancer is internal (accessible only from within the VPC) or external (internet-facing).
     - `load_balancer_type`: The type of load balancer (application in this case).
     - `security_groups`: The security group(s) associated with the load balancer to control inbound and outbound traffic.
     - `subnets`: The list of subnet IDs where the load balancer will be placed.
     - `tags`: Tags applied to the load balancer for identification and organization.

2. **ALB Listener**:
   - Resource Type: `aws_lb_listener`
   - Description: Creates a listener for the ALB, which listens for incoming connections on a specified port and forwards them to the target groups.
   - Attributes:
     - `load_balancer_arn`: The Amazon Resource Name (ARN) of the load balancer.
     - `port`: The port on which the listener listens for incoming traffic.
     - `protocol`: The protocol used for routing traffic to the targets (HTTP in this case).
     - `default_action`: Defines the action to take for requests that match the listener. In this case, it forwards requests to the specified target group.

3. **Target Group**:
   - Resource Type: `aws_lb_target_group`
   - Description: Creates a target group for the load balancer, specifying the targets (instances) that will receive traffic from the load balancer.
   - Attributes:
     - `name`: The name of the target group.
     - `port`: The port on which the targets receive traffic.
     - `protocol`: The protocol used for routing traffic to the targets (HTTP in this case).
     - `vpc_id`: The ID of the VPC in which the target group is created.

4. **Target Group Attachment (Instance 1)**:
   - Resource Type: `aws_lb_target_group_attachment`
   - Description: Attaches the specified instance (target) to the target group, enabling the instance to receive traffic from the load balancer.
   - Attributes:
     - `target_group_arn`: The ARN of the target group to which the instance is attached.
     - `target_id`: The ID of the target (instance) to be attached.
     - `port`: The port on which the instance receives traffic.

5. **Target Group Attachment (Instance 2)**:
   - Similar to the previous resource, this attaches the second instance to the same target group for load balancing.

These resources collectively define the configuration for an application load balancer and its associated listener and target groups. The load balancer distributes incoming traffic across the specified instances, providing high availability and fault tolerance for the application.

### Output File

- **`outputs.tf`**: Defines outputs for retrieving information about the ALB, such as its DNS name.

Let's explain each output defined in the `outputs.tf` file:

1. **ALB DNS Name**:
   - Output Name: `alb_dns_name`
   - Description: Provides the DNS name of the Application Load Balancer (ALB), which can be used to access the web application.
   - Value: The DNS name of the ALB (`aws_lb.test.dns_name`).

2. **Database Endpoint**:
   - Output Name: `db_endpoint`
   - Description: Provides the endpoint (host name) of the database instance, which can be used to connect to the database.
   - Value: The endpoint of the database instance (`aws_db_instance.db_1.endpoint`).

3. **Database Port**:
   - Output Name: `db_port`
   - Description: Provides the port number on which the database is listening for connections.
   - Value: The port number of the database instance (`aws_db_instance.db_1.port`).

4. **Instance 1 ID**:
   - Output Name: `instance_1_id`
   - Description: Provides the unique identifier (ID) of the first EC2 instance.
   - Value: The ID of the first EC2 instance (`aws_instance.my_server_1.id`).

5. **Instance 2 ID**:
   - Output Name: `instance_2_id`
   - Description: Provides the unique identifier (ID) of the second EC2 instance.
   - Value: The ID of the second EC2 instance (`aws_instance.my_server_2.id`).

6. **Instance 1 Public IP**:
   - Output Name: `instance_1_public_ip`
   - Description: Provides the public IP address of the first EC2 instance.
   - Value: The public IP address of the first EC2 instance (`aws_instance.my_server_1.public_ip`).

7. **Instance 2 Public IP**:
   - Output Name: `instance_2_public_ip`
   - Description: Provides the public IP address of the second EC2 instance.
   - Value: The public IP address of the second EC2 instance (`aws_instance.my_server_2.public_ip`).

These outputs allow users to easily retrieve important information about the deployed infrastructure, such as the ALB DNS name, database endpoint, instance IDs, and public IP addresses, facilitating access and management of the resources.

## Additional step
These resources enable the creation of a table in the MySQL database and the insertion of text file contents into that table, leveraging local-exec provisioners to execute commands on the local machine. It's important to note that using local-exec provisioners to interact with external systems like databases can have security and reliability implications and should be used with caution.

Let's break down the Terraform code:

#### MySQL Table Creation Script:

1. **Null Resource - Create Table**:
   - Description: This resource uses a null resource to execute a local command for creating a table in the MySQL database. It depends on the existence of the AWS RDS instance defined earlier (`aws_db_instance.db_1`).
   
   ```hcl
   resource "null_resource" "create_table" {
     depends_on = [aws_db_instance.db_1]

     provisioner "local-exec" {
       command = <<-EOT
         mysql -h ${aws_db_instance.db_1.endpoint} -u ${var.db_username} -p${var.db_password} -e "CREATE TABLE IF NOT EXISTS files (id INT AUTO_INCREMENT PRIMARY KEY, file_content BLOB);"
       EOT
     }
   }
   ```

#### Store Text File Contents in Database:

2. **Local File Content**:
   - Description: This block defines a local variable `file_content` to read the contents of a text file named `textfile.txt`.
   
   ```hcl
   locals {
     file_content = file("${path.module}file/textfile.txt")
   }
   ```

3. **Null Resource - Store File in DB**:
   - Description: This resource uses a null resource to execute a local command for storing the text file contents into the database. It depends on the completion of the table creation (`null_resource.create_table`).
   
   ```hcl
   resource "null_resource" "store_file_in_db" {
     depends_on = [null_resource.create_table]

     provisioner "local-exec" {
       command = <<-EOT
         echo '${base64encode(local.file_content)}' | mysql -h ${aws_db_instance.db_1.endpoint} -u ${var.db_username} -p${var.db_password} -e "INSERT INTO files (file_content) VALUES (FROM_BASE64(@@{stdin}));"
       EOT
     }
   }
   ```

## tfvars file

The `terraform.tfvars` file contains sensitive information such as AWS credentials, including access keys, secret keys, and other configuration details necessary to authenticate with the AWS API and provision resources. Exposing this file or its contents can pose significant security risks:

1. **AWS Credentials Exposure**: If unauthorized individuals gain access to the `terraform.tfvars` file, they can obtain AWS access and secret keys. These credentials provide full access to your AWS account and can be used to manipulate resources, incur costs, or access sensitive data.

2. **Potential Data Breach**: If the `terraform.tfvars` file is stored in a repository that is publicly accessible or shared with unauthorized users, it increases the risk of a data breach. Attackers could use the exposed credentials to compromise the AWS account, steal sensitive data, or launch malicious activities.

3. **Unauthorized Resource Provisioning**: With access to AWS credentials, attackers can use Terraform to provision additional resources in the compromised AWS environment. This could result in unexpected costs, infrastructure misconfiguration, or deployment of malicious resources.

4. **Compliance and Regulatory Violations**: Depending on the nature of the data and the industry regulations applicable to your organization, exposing AWS credentials and sensitive configuration information may lead to non-compliance with regulations such as GDPR, HIPAA, or PCI DSS.

To mitigate these security risks, consider the following best practices:

- **Restrict Access**: Limit access to the `terraform.tfvars` file to authorized users only. Use appropriate access controls and permissions to ensure that only trusted individuals can view or modify the file.

- **Secure Storage**: Store the `terraform.tfvars` file securely, preferably outside of version control systems and in a location with restricted access. Consider using secure storage solutions or secrets management tools to store sensitive information encrypted.

- **Rotate Credentials**: Regularly rotate AWS access and secret keys to mitigate the impact of potential credential compromise. Implement automated key rotation policies and practices to ensure that credentials are regularly updated.

- **Use Temporary Credentials**: Avoid hardcoding AWS credentials directly into the `terraform.tfvars` file. Instead, use temporary security credentials, IAM roles, or AWS Identity and Access Management (IAM) instance profiles with limited privileges.

- **Monitor and Audit**: Monitor access to AWS resources, review AWS CloudTrail logs for suspicious activities, and implement auditing mechanisms to detect unauthorized access attempts or changes to resources.

By implementing these security measures, you can reduce the risk of unauthorized access, data breaches, and compliance violations associated with the exposure of sensitive information in the `terraform.tfvars` file.

Let's break down the contents of the `terraform.tfvars` file:

#### Network Configuration:

1. **Region**:
   - Description: Specifies the AWS region where the infrastructure will be provisioned.
   - Value: "eu-west-1" (EU Ireland region).

2. **Project Name**:
   - Description: Name of the project or application being deployed.
   - Value: "two-tier-architecture".

3. **VPC CIDR Block**:
   - Description: CIDR block for the Virtual Private Cloud (VPC) being created.
   - Value: "10.0.0.0/16".

4. **Public Subnet 1 CIDR Block**:
   - Description: CIDR block for the first public subnet within the VPC.
   - Value: "10.0.0.0/24".

5. **Public Subnet 1 Availability Zone**:
   - Description: Availability Zone for the first public subnet.
   - Value: "eu-west-1a".

6. **Public Subnet 2 CIDR Block**:
   - Description: CIDR block for the second public subnet within the VPC.
   - Value: "10.0.1.0/24".

7. **Public Subnet 2 Availability Zone**:
   - Description: Availability Zone for the second public subnet.
   - Value: "eu-west-1b".

8. **Private Subnet 1 CIDR Block**:
   - Description: CIDR block for the first private subnet within the VPC.
   - Value: "10.0.2.0/24".

9. **Private Subnet 1 Availability Zone**:
   - Description: Availability Zone for the first private subnet.
   - Value: "eu-west-1a".

10. **Private Subnet 2 CIDR Block**:
    - Description: CIDR block for the second private subnet within the VPC.
    - Value: "10.0.3.0/24".

11. **Private Subnet 2 Availability Zone**:
    - Description: Availability Zone for the second private subnet.
    - Value: "eu-west-1b".

#### Compute, Database, Security Groups, Application Load Balancer (ALB):

12. **Security Group Name**:
    - Description: Name of the security group to be created.
    - Value: "two-tier-sg".

13. **Load Balancer Security Group Name**:
    - Description: Name of the security group for the load balancer.
    - Value: "two-tier-lb-sg".

14. **Instance Type**:
    - Description: Type of EC2 instances being used.
    - Value: "t2.micro".

15. **Key Pair Name**:
    - Description: Name of the key pair used for EC2 instances.
    - Value: "test-app-key".

16. **Target Group Name**:
    - Description: Name of the target group associated with the ALB.
    - Value: "two-tier-tg".

17. **Load Balancer Name**:
    - Description: Name of the application load balancer.
    - Value: "two-tier-alb".

18. **Database Security Group Name**:
    - Description: Name of the security group for the database.
    - Value: "two-tier-db-sg".

19. **Database Subnet Group Name**:
    - Description: Name of the subnet group for the database.
    - Value: "two-tier-db-sub-grp".

20. **Database Username**:
    - Description: Username for accessing the database.
    - Value: "neyo".

21. **Database Password**:
    - Description: Password for accessing the database.
    - Value: "neyo1234".

These values define the parameters and configurations used by the Terraform script to provision infrastructure resources in AWS.

## Usage

To deploy the two-tier architecture, follow these steps:

1. Initialize Terraform:

    ```bash
    terraform init
    ```

2. Validate the setup for errors:

    ```bash
    terraform validate
    ```

3. Review the execution plan:

    ```bash
    terraform plan
    ```

4. Apply the configuration to create resources:

    ```bash
    terraform apply --auto-approve
    ```

## After successful deployment

After successful deployment, you can access the following outputs:

- **ALB DNS Name**: The DNS name of the Application Load Balancer.
- **Database Endpoint**: Endpoint of the RDS database.
- **Database Port**: Port number used by the RDS database.
- **Instance IDs and Public IPs**: IDs and public IP addresses of the EC2 instances.

## Cleanup

To avoid incurring charges, remember to destroy the resources when no longer needed:

```bash
terraform destroy --auto-approve
```

## Security Considerations

Ensure that your AWS credentials and sensitive information are stored securely and not exposed in version control. Consider using tools like AWS Secrets Manager for managing passwords securely.

## References

- Terraform AWS Provider Documentation
- Mathesh-me GitHub Repository


## Contributing

Contributions are welcome! If you find any issues or improvements, feel free to open a pull request.

## License

This Terraform configuration is provided under the [MIT License](LICENSE).
