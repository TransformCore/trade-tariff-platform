output "aws_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this[0].id
}

output "aws_cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.this[0].arn
}
