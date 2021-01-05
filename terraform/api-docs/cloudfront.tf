resource "aws_cloudfront_distribution" "distribution" {
  provider = aws.global
  origin {
    domain_name = var.origin_endpoint
    origin_id   = "origin-${var.origin_endpoint}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  aliases = concat([var.fqdn],var.aliases,)

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-${var.origin_endpoint}"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.cdn_certificate.arn
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }

  depends_on = [
    aws_acm_certificate.cdn_certificate,
    aws_acm_certificate_validation.validation
  ]
}

resource "aws_route53_record" "cdn-record" {
  name    = var.fqdn
  type    = "CNAME"
  ttl     = 60
  records = [aws_cloudfront_distribution.distribution.domain_name]
  zone_id = data.aws_route53_zone.selected.id
}
