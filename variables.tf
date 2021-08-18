# ---------------------------------------------------------------------------------------------------------------------
# VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to create things in."
  //default     = "us-east-2"
}

variable "owner" {
  description = "The owner of resources"
}

variable "private_subnet_cidr_block" {
  type        = list(string)
  description = "The private subnet cidr block"
}

variable "key_name" {
  description = "The key pair name to access ec2"
}

variable "domain" {
  type        = string
  description = "The AD domain name"
}
variable "private_subnet_name" {
  type        = list(string)
  description = "The private subnet name"
}

variable "product_name" {
  type        = string
  description = "The short name for your product"
}
variable "public_subnet_cidr_block" {
  type        = list(string)
  description = "The public subnet cidr block"
}
variable "aws_profile" {
  description = "AWS profile"
}

variable "stack" {
  description = "Name of the stack."
  default     = "GameDay"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"

}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "aws_ecr" {
  description = "AWS ECR "
}



variable "family" {
  description = "Family of the Task Definition"
  default     = "petclinic"
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "task_count" {
  description = "Number of ECS tasks to run"
  default     = 3
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "fargate-task-service-role" {
  description = "Name of the stack."
  // default     = "GameDay"
}

variable "db_instance_type" {
  description = "RDS instance type"
  default     = "db.m5.large"
}

# variable "db_name" {
#   description = "RDS DB name"
#   default     = "petclinic"
# }

# variable "db_user" {
#   description = "RDS DB username"
#   default     = "root"
# }

variable "ad_password" {
  description = "RDS DB password"
  sensitive   = true
}

# variable "db_profile" {
#   description = "RDS Profile"
#   default     = "mysql"
# }

variable "db_initialize" {
  description = "RDS initialize"
  default     = "yes"
}

variable "cw_log_group" {
  description = "CloudWatch Log Group"
  default     = "GameDay"
}

variable "cw_log_stream" {
  description = "CloudWatch Log Stream"
  default     = "fargate"
}

# Source repo name and branch

variable "source_repo_name" {
  description = "Source repo name"
  type        = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  type        = string
}


# Image repo name for ECR

variable "image_repo_name" {
  description = "Image repo name"
  type        = string
}
variable "app_id" {
  type        = string
  description = "The customer application id for the product this will be used to tag resources for billing purposes"
}

variable "environment" {
  type        = string
  description = "The environment for the application"
}

#Variables for DMS

variable "source_database_host" {
  type        = string
  description = "The ip of source host"
}

variable "source_database_name" {
  type        = string
  description = "The name of source database"
}

variable "source_database_username" {
  type        = string
  description = "The user name of source database"
}
variable "source_database_password" {
  type        = string
  description = "The password of source_database_username "
}

variable "database_name" {
  type        = string
  description = "The name of source database"
}

variable "dms_username" {
  type        = string
  description = "The user name of source database"
}
variable "dms_password" {
  type        = string
  description = "The password of source_database_username "
}

variable "web_username" {
  type        = string
  description = "The password of web_username "
}

variable "web_password" {
  type        = string
  description = "The password of web_username "
}