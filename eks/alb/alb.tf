resource "aws_alb" "main" {
  name               = format("%s-%s", var.cluster_name, local.random_number)
  internal           = local.alb_defaults["internal"]
  load_balancer_type = local.alb_defaults["load_balancer_type"]
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids_list

  tags = {
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/cluster"  = var.cluster_name
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  for_each = var.node_group_names

  autoscaling_group_name = var.autoscale_group_names[each.value]
  alb_target_group_arn   = aws_alb_target_group.main.arn
}

resource "aws_alb_target_group" "main" {
  name        = format("%s-%s", var.cluster_name, local.random_number)
  port        = lookup(local.alb_defaults, "node_port")
  protocol    = "HTTP"
  target_type = lookup(local.alb_defaults, "target_type")
  vpc_id      = var.vpcid
}

resource "aws_alb_listener" "http-forward" {
  count = local.alb_defaults["enable_http"] == true && local.alb_defaults["http_redirect"] == false ? 1 : 0

  load_balancer_arn = aws_alb.main.arn
  port              = local.alb_defaults["http_port"]
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}

resource "aws_alb_listener" "http-redirect" {
  count = local.alb_defaults["enable_https"] == true && local.alb_defaults["http_redirect"] == true ? 1 : 0

  load_balancer_arn = aws_alb.main.arn
  port              = local.alb_defaults["http_port"]
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = local.alb_defaults["https_port"]
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  count = local.alb_defaults["enable_https"] == true ? 1 : 0

  load_balancer_arn = aws_alb.main.arn
  port              = local.alb_defaults["https_port"]
  protocol          = "HTTPS"
  ssl_policy        = local.alb_defaults["ssl_policy"]
  certificate_arn   = local.alb_defaults["certificate_arn"]
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
}