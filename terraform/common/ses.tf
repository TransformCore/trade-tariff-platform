
resource "aws_ses_email_identity" "example" {
  email = var.notification_email
}
