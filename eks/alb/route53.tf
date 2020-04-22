data "aws_route53_zone" "www" {
  count        = local.route_53_count
  name         = local.route_53["domain_name"]
  private_zone = local.route_53["private_zone"]
}

resource "aws_route53_record" "hostname" {
  count = local.route_53_count

  zone_id = data.aws_route53_zone.www[0].zone_id
  name    = local.route_53["host_name"]
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}
