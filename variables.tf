variable "aws_region" {}
variable "key_pair_name" {}
variable "aws_account_name" {}
variable "aws_account_id" {}
variable "domain_name" {}
variable "instance_type" {}
variable "desired_instance_count" {}
variable "min_instance_count" {}
variable "max_instance_count" {}
variable "cluster_name" {}
variable "eks_version" {}
variable "app_namespace" {}
variable "node_port" {}
variable "enable_https" {}
variable "host_name" { default = "" }
variable "tags" { default = {} }
variable "subnets_prv" {type = list }
variable "subnets_pub" {type = list }
variable "vpc_id" {}
