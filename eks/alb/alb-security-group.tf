#
# ALB Security group for EKS cluster 
#

resource "aws_security_group" "main" {
  name        = format("%s-%s", var.security_group_name, local.random_number)
  description = "ALB Security group for EKS cluster "
  vpc_id      = var.vpcid

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s-%s", var.security_group_name, local.random_number)
    ClusterName = var.cluster_name
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "alb-to-nodes" {
  description              = "Allows users connect to apps through alb"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = var.cluster_security_group_id
  source_security_group_id = aws_security_group.main.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "http-inbound" {
  count             = local.alb_defaults["enable_http"] ? 1 : 0
  from_port         = local.alb_defaults["http_port"]
  to_port           = local.alb_defaults["http_port"]
  cidr_blocks       = [local.alb_defaults["cidr_blocks"]]
  security_group_id = aws_security_group.main.id
  protocol          = "tcp"
  type              = "ingress"
}

resource "aws_security_group_rule" "https-inbound" {
  count             = local.alb_defaults["enable_https"] ? 1 : 0
  from_port         = local.alb_defaults["https_port"]
  to_port           = local.alb_defaults["https_port"]
  cidr_blocks       = [local.alb_defaults["cidr_blocks"]]
  security_group_id = aws_security_group.main.id
  protocol          = "tcp"
  type              = "ingress"
}
