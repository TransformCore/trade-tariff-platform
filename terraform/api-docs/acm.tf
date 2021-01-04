resource "aws_acm_certificate" "cdn_certificate" {
  provider                  = aws.global
  domain_name               = var.fqdn
  subject_alternative_names = var.aliases
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cdn_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.selected.zone_id
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
}

resource "aws_acm_certificate_validation" "validation" {
  provider = aws.global
  certificate_arn         = aws_acm_certificate.cdn_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}
