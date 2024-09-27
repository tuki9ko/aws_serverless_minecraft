resource "aws_route53_record" "minecraft" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.minecraft.dns_name
    zone_id                = aws_lb.minecraft.zone_id
    evaluate_target_health = false
  }
}