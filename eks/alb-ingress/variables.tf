variable "service_account_arn" {
  type        = string
  description = "Service account arn"
}

variable "vpcid" {}

variable "cluster_name" {}

variable "region" {}

variable "app_namespace" {
  default = "kube-system"
  type    = string
}

variable "service_port" {
  default = "8080"
  type    = string
}

variable "service_name" {
  default = "nginx"
  type    = string
}

variable "subnet_ids_list" {
  type    = list
  default = []
}
