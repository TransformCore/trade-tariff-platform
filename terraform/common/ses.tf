resource "aws_ses_email_identity" "notify_email" {
  email = "trade-tariff-support@enginegroup.com"
}

resource "aws_ses_domain_identity" "tariff_domain" {
  domain = "trade-tariff.service.gov.uk"
}

resource "aws_ses_domain_identity_verification" "tariff-domain-verification" {
  domain = aws_ses_domain_identity.tariff_domain.id
  depends_on = [aws_route53_record.tariff_domain_verification_record]
}

resource "aws_route53_record" "tariff_domain_verification_record" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "_amazonses.${aws_ses_domain_identity.tariff_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.tariff_domain.verification_token]
}

resource "aws_iam_user_policy" "ses-policy" {
  name   = "ses-send-emails"
  policy = data.aws_iam_policy_document.ses-policy.json
  user   = aws_iam_user.service-account.name
}

data "aws_iam_policy_document" "ses-policy" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      "*"
    ]
  }
}
