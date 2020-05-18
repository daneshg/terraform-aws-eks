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

variable "internal" {
  default     = true
  description = "Load balancer scheme"
  type        = bool
}

variable "load_balancer_type" {
  default     = "application"
  description = "Type of loadbalancer - application or network"
  type        = string
}

variable "target_type" {
  default     = "instance"
  description = ""
  type        = string
}

variable "access_logs" {
  default     = {}
  description = "Access logs for ALB"
}

variable "tags" {
  default     = {}
  description = "Tags to add for ALB"
  type        = map
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "cidr_blocks" {
  type        = string
  default     = "0.0.0.0/0"
  description = "cidr blocks for inbound access"
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
  type    = string
}

variable "http_port" {
  default = 80
  type    = number
}

variable "https_port" {
  default = 443
  type    = number
}

variable "enable_http" {
  type    = bool
  default = false
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "http_redirect" {
  type    = bool
  default = false
}

variable "node_port" {
  default     = "30845"
  description = "NodePort value"
}

variable "certificate_arn" {
  default     = ""
  description = "Required if https is enabled"
}

variable "autoscale_group_names" {
  type        = any
  default     = {}
  description = "*Autoscaling group names of EKS cluster; ex: { node1: idddd }"
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
    domain_name   = ""
    private_zone  = false
    host_name     = ""
    region_prefix = ""
  }
}

variable "node_group_names" {
  type        = any
  default     = {}
  description = "Node group names are required to get their corresponding autoscaling group ids"
}


