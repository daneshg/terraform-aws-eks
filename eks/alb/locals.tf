locals {
  random_number = random_id.this.id
  alb_defaults  = merge(var.alb_defaults, var.alb)
  route_53_count = length(var.route_53) > 0 ? 1 : 0
  route_53 = merge(var.route_53_defaults, var.route_53)
}


