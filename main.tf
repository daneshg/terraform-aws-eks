provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_acm_certificate" "acm" {
  count    = var.enable_https ? 1 : 0
  domain   = format("*.%s", var.domain_name)
  statuses = ["ISSUED"]
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  cluster_name    = var.cluster_name
  eks_version     = var.eks_version
  subnet_ids_list = var.subnets_prv
  vpcid           = var.vpc_id

  work_groups = [
    {
      node_group_name = format("%s-node-grp-1", var.cluster_name)
      ec2_ssh_key     = var.key_pair_name
      desired_size    = var.desired_instance_count
      max_size        = var.max_instance_count
      min_size        = var.min_instance_count
      instance_types  = var.instance_type
      labels = {}
      tags = var.tags
    },
    {
      node_group_name = format("%s-node-grp-2", var.cluster_name)
      ec2_ssh_key     = var.key_pair_name
      desired_size    = var.desired_instance_count
      max_size        = var.max_instance_count
      min_size        = var.min_instance_count
      instance_types  = var.instance_type
      labels = {}
      tags = var.tags
    }
  ]
}

module "alb" {
  source = "./modules/eks-alb"

  cluster_name              = module.eks_cluster.cluster_id
  subnet_ids_list           = var.subnets_pub
  vpcid                     = var.vpc_id
  node_group_names          = module.eks_cluster.node_group_names
  autoscale_group_names     = module.eks_cluster.autoscale_group_names
  cluster_security_group_id = module.eks_cluster.cluster_security_group_id
  tags                      = var.tags
  node_port                 = var.node_port
  enable_https              = var.enable_https
  certificate_arn           = (var.enable_https) ? data.aws_acm_certificate.acm.0.arn : ""
  internal                  = false

  route_53 = {
    "domain_name"   = var.domain_name,
    "host_name"     = var.host_name,
  }

}

