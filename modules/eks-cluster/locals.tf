locals {
  random_number = random_id.this.id
  enable_worker = length(var.work_groups) > 0 ? 1 : 0 # Create worker node is work_groups block exists

  node_group_names = { for key, val in var.work_groups : lookup(val, "node_group_name") => lookup(val, "node_group_name") }

  node_groups_defaults = { for key, val in var.work_groups : lookup(val, "node_group_name") => merge({
    tags           = var.defaults["tags"]
    labels         = var.defaults["labels"]
    cluster_name   = aws_eks_cluster.main.name
    node_role_arn  = aws_iam_role.wrk-grp[0].arn
    min_size       = var.defaults["min_size"]
    max_size       = var.defaults["max_size"]
    desired_size   = var.defaults["desired_size"]
    disk_size      = var.defaults["disk_size"]
    instance_types = var.defaults["instance_types"]
  }, val) }

}
