resource "aws_cloudfront_cache_policy" "cache_all_qsa" {
  name        = "Cache-All-QSA-${var.environment_name}"
  comment     = "Cache all QSA (managed by terraform)"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}
