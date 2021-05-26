resource "aws_iam_access_key" "service-account" {
  user = aws_iam_user.service-account.name
}

resource "aws_iam_user" "service-account" {
  name = "trade-tariff-service-account"
  path = "/system/"
}

output "iam_id" {
  value = aws_iam_access_key.service-account.id
}

output "secret" {
  value = aws_iam_access_key.service-account.secret
  sensitive = true
}
