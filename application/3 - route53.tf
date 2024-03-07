resource "aws_route53_zone" "eks_zone" {
  name = "giddychild.com"
}

resource "aws_route53_record" "eks_record" {
  zone_id = aws_route53_zone.eks_zone.zone_id
  name    = "myapp.giddychild.com"
  type    = "A"

  alias {
    name                   = aws_lb.eks_alb.dns_name
    zone_id                = aws_lb.eks_alb.zone_id
    evaluate_target_health = false  # Typically set to false for ALBs unless health checks are configured to evaluate target health
  }
}
