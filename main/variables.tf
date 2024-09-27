variable "aws_region" {
  description = "aws region"
  default     = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "public subnet cidr block"
  default     = "10.0.1.0/24"
}

variable "cluster_name" {
  description = "ecs cluster name"
  default     = "minecraft-cluster"
}

variable "efs_name" {
  description = "efs name"
  default     = "minecraft-efs"
}

variable "domain_name" {
  description = "domain"
  type        = string
  default     = "FIXME"
}

variable "hosted_zone_id" {
  description = "hosted zone id"
  type        = string
  default     = "FIXME
}