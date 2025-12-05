variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
  
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "project-ecs-cicd"
  
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "az_count" {
  description = "The number of availability zones to use"
  type        = number
  default     = 2
}

variable "ecs_desired_count" {
  description = "The desired number of ECS tasks"
  type        = number
  default     = 2
  
}

variable "container_cpu" {
  description = "The number of CPU units to allocate to the ECS task"
  type        = number
  default     = 256
  
}

variable "container_memory" {
  description = "The amount of memory (in MiB) to allocate to the ECS task"
  type        = number
  default     = 512
  
}

variable "container_port" {
  description = "The port on which the container will listen"
  type        = number
  default     = 5000
  
}

variable "container_image_tag" {
  description = "The Docker image tag to use for the container"
  type        = string
  default     = "latest"
  
}