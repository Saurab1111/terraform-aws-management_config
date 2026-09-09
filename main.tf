resource "aws_iam_role" "config" {
  count = var.iam_role_arn == "" ? 1 : 0

  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config" {
  count = var.iam_role_arn == "" ? 1 : 0

  role       = aws_iam_role.config[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

locals {
  config_role_arn = var.iam_role_arn != "" ? var.iam_role_arn : aws_iam_role.config[0].arn
}

resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = local.config_role_arn

  recording_group {
    all_supported                 = length(var.resource_types) == 0
    include_global_resource_types = var.include_global_resource_types
    resource_types                = length(var.resource_types) > 0 ? var.resource_types : null
    recording_strategy {
      use_only = length(var.resource_types) == 0 ? "ALL_SUPPORTED_RESOURCE_TYPES" : "INCLUSION_BY_RESOURCE_TYPES"
    }
  }

  recording_mode {
    recording_frequency = var.recording_frequency
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "${var.name}-delivery-channel"
  s3_bucket_name = var.s3_bucket_name
  sns_topic_arn  = var.sns_topic_arn != "" ? var.sns_topic_arn : null

  snapshot_delivery_properties {
    delivery_frequency = var.delivery_channel_snapshot_frequency
  }

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  count = var.enable_config_recorder ? 1 : 0

  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}
