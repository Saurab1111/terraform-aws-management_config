output "configuration_recorder_name" {
  description = "AWS Config configuration recorder name."
  value       = aws_config_configuration_recorder.this.name
}

output "delivery_channel_name" {
  description = "AWS Config delivery channel name."
  value       = aws_config_delivery_channel.this.name
}

output "config_role_arn" {
  description = "IAM role ARN used by AWS Config."
  value       = local.config_role_arn
}
