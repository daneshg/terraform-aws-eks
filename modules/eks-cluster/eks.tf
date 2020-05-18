resource "aws_eks_cluster" "main" {

  name     = var.cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids_list
  }

  enabled_cluster_log_types = ["api", "audit"]

  depends_on = [
    aws_iam_role_policy_attachment.eks-role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-role-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.main
  ]

}
