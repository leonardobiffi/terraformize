provider "aws" {
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket = "jn2-dev-tfstate-terraform"
    region = "us-east-1"
    encrypt = true
  }
}

module "magento_v1" {
  source              = "git@bitbucket.org:jn2/terraform-module-magento-v1.git"
  theme               = var.theme
  store               = var.store
  store_domains       = var.store_domains
  certificate_domain  = var.certificate_domain
  modman_plan         = var.modman_plan
  modman_extensions   = var.modman_extensions
  container_cpu       = var.container_cpu
  container_memory    = var.container_memory
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity
  metric_type         = var.metric_type
  target_value        = var.target_value
  dedicated_db_host   = var.dedicated_db_host
  # Only if dedicate is FALSE
  cluster_name        = var.cluster_name

  tags = zipmap(var.tag_name, var.tag_value)
}

# Variables
variable "theme" {
  type = string
}

variable "store" {
  type = string
}

variable "store_domains" {
  type = list
}

variable "certificate_domain" {
  type = string
}

variable "modman_plan" {
  type = string
}

variable "modman_extensions" {
  type = list
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "metric_type" {
  type = string
}

variable "target_value" {
  type = number
}

variable "dedicated_db_host" {
  type = string
}

variable "cluster_name" {
  type = string
  default = ""
}

variable "tag_name" {
  type = list
}

variable "tag_value" {
  type = list
}