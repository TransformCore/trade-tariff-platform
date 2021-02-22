resource "aws_cloudfront_origin_request_policy" "forward_all_qsa" {
  name        = "Forward-All-QSA-${var.environment_name}"
  comment     = "Forward all QSA (managed by terraform)"
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "allViewer"
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}
