output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.main.arn
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority.0.data
}

output "identity-oidc-issuer" {
  value = aws_eks_cluster.main.identity.0.oidc.0.issuer
}

output "random-number" {
  value = local.random_number
}

output "aws_iam_openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.cluster[*].arn
}

output "service_account_arn" {
  value = aws_iam_role.account-role[*].arn
}

output "autoscale_group_names" {
  value = { for key, val in local.node_group_names : key => aws_eks_node_group.main[val].resources.0.autoscaling_groups.0.name }
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.main.vpc_config.0.cluster_security_group_id
}

output "node_group_names" {
  value = local.node_group_names
}
