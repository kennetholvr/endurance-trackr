resource "aws_kms_key" "data" {
  description             = "FF ${var.env} data key"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags                    = { Purpose = "data-encryption" }
}

resource "aws_kms_alias" "data" {
  name          = "alias/ff-${var.env}-data"
  target_key_id = aws_kms_key.data.key_id
}