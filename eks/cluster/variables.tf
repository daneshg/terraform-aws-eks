variable "cluster_name" {
  description = "Name of the eks cluster to be deployed."
  type        = string
}

variable "service_role" {
  description = "EKS service role"
  default     = "service-role"
  type        = string
}

variable "node_group_role" {
  description = "EKS node group role "
  default     = "node-group-role"
}

variable "subnet_ids_list" {
  description = "List of subnet ids "
  type        = list(string)
}

variable "vpcid" {
  description = "VPC ID to be linked with EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "EKS version to be deployed"
  default     = "1.14"
  type        = string
}

variable "security_group_name" {
  default = "terraform-sg"
  type    = string
}

variable "work_groups" {
  description = "List of work groups"
  type        = list
  default     = []
}

variable "defaults" {
  description = "Default values for node group"
  default = {
    tags           = {} #tags as a map; key-value pair
    labels         = {} #labels as a map; key-value pair
    min_size       = 1
    max_size       = 1
    desired_size   = 1
    disk_size      = 50
    instance_types = "t3.medium"
  }
  type = any
}

variable "service_account_name" {
  description = "Service account name for enabling ingress in EKS cluster"
  type        = string
  default     = "alb-ingress-controller"
}

variable "k8s_namespace" {
  description = "K8s namespace"
  type        = string
  default     = "kube-system"
}

variable "create_service_account" {
  description = "Creates service account EKS cluster"
  type        = bool
  default     = false
}

variable "thumbprint" {
  default = "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"
  type    = string
}
