resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = "tariff-api-dev.london.cloudapps.digital"
    origin_id   = "origin-tariff-api-dev.london.cloudapps.digital"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy = "match-viewer"
      origin_read_timeout = 30
      origin_ssl_protocols = ["TLSv1.1","TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  price_class = "PriceClass_100"

  aliases = [ "api-dev.trade-tariff.service.gov.uk"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-tariff-api-dev.london.cloudapps.digital"

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
    acm_certificate_arn = "arn:aws:acm:us-east-1:777015734912:certificate/59c22c7f-fbb5-4fc7-955f-00595c565a3b"
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method = "sni-only"
  }
}


data "aws_route53_zone" "selected" {
  name         = "trade-tariff.service.gov.uk."
  private_zone = false
}

resource "aws_route53_record" "cdn-record" {
  name = "api-dev.trade-tariff.service.gov.uk"
  type = "CNAME"
  records = [aws_cloudfront_distribution.distribution.domain_name]
  zone_id = data.aws_route53_zone.selected.id
}
