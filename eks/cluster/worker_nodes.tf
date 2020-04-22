resource "aws_eks_node_group" "main" {
  for_each = local.node_groups_defaults

  cluster_name = each.value["cluster_name"]

  node_group_name = each.value["node_group_name"]
  node_role_arn   = each.value["node_role_arn"]
  subnet_ids      = var.subnet_ids_list


  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  disk_size = each.value["disk_size"]

  labels = each.value["labels"]

  tags = each.value["tags"]

  remote_access {
    ec2_ssh_key = each.value["ec2_ssh_key"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.wrk-grp-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.wrk-grp-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.wrk-grp-AmazonEC2ContainerRegistryReadOnly,
  ]
}
