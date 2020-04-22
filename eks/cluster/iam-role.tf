#
# IAM Role for EKS Cluster
#
resource "aws_iam_role" "eks-role" {
  name = format("%s-%s-%s", var.cluster_name, var.service_role, local.random_number)

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}

resource "aws_iam_role_policy_attachment" "eks-role-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-role.name
}


#
# IAM Role for EKS Node Group
#
resource "aws_iam_role" "wrk-grp" {
  count = local.enable_worker

  name = format("%s-%s-%s", var.cluster_name, var.node_group_role, local.random_number)


  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "wrk-grp-AmazonEKSWorkerNodePolicy" {
  count      = local.enable_worker
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.wrk-grp[0].name
}

resource "aws_iam_role_policy_attachment" "wrk-grp-AmazonEKS_CNI_Policy" {
  count      = local.enable_worker
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.wrk-grp[0].name
}

resource "aws_iam_role_policy_attachment" "wrk-grp-AmazonEC2ContainerRegistryReadOnly" {
  count      = local.enable_worker
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.wrk-grp[0].name
}
