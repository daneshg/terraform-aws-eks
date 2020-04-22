variable "cluster_name" {
  description = "Name of the eks cluster to which ALB need to be deployed."
  type        = string
}

variable "subnet_ids_list" {
  description = "List of subnet ids "
  type        = list(string)
}

variable "vpcid" {
  description = "VPC ID to be linked with EKS cluster"
  type        = string
}

variable "security_group_name" {
  default = "terraform-sg"
  type    = string
}

variable "alb_defaults" {
  description = "Default values for alb"
  type        = any
  default = {
    internal                   = true          #scheme - internal/internet-facing
    load_balancer_type         = "application" #Application/Network
    target_type                = "instance"
    access_logs                = {}
    tags                       = {}
    enable_deletion_protection = false
    cidr_blocks                = "0.0.0.0/0" #cidr blocks for inbound access
    ssl_policy                 = "ELBSecurityPolicy-2016-08"
    # certificate_arn = "" (*required if https)
    http_port     = 80
    https_port    = 443
    enable_http   = false
    enable_https  = false
    http_redirect = false
    # node_port           =   null   ## Mandatory argumnet 
  }
}

variable "alb" {
  type        = any
  description = "ALB settings"
  default     = {}
}

variable "autoscale_group_names" {
  type        = map
  default     = {}
  description = "*Autoscaling group names of EKS cluster EX: { node1: autoScalingGroupName }"
}

variable "cluster_security_group_id" {
  type        = string
  description = "*EKS cluster security group ID; Enables communication between Loadbalancer and EKS cluster"
}

variable "route_53" {
  description = "Enables route53 setting if provided."
  type        = any
  default     = {}
}

variable "route_53_defaults" {
  description = "Include route 53 default conf"
  default = {
    domain_name  = ""
    private_zone = false
    host_name    = ""
  }
}

variable "node_group_names" {
  type        = map
  default     = {}
  description = "Node group names are required to get their corresponding autoscaling group ids"
}
