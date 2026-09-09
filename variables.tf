variable "name" {
  description = "Name prefix for AWS Config resources."
  type        = string
  default     = "management-config"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for AWS Config snapshots and configuration history."
  type        = string
}

variable "sns_topic_arn" {
  description = "Optional SNS topic ARN for AWS Config notifications."
  type        = string
  default     = ""
}

variable "iam_role_arn" {
  description = "IAM role ARN used by AWS Config recorder."
  type        = string
  default     = ""
}

variable "include_global_resource_types" {
  description = "Whether to include global resource types in recording."
  type        = bool
  default     = true
}

variable "recording_frequency" {
  description = "Recording frequency for AWS Config recorder."
  type        = string
  default     = "CONTINUOUS"

  validation {
    condition     = contains(["CONTINUOUS", "DAILY"], var.recording_frequency)
    error_message = "recording_frequency must be CONTINUOUS or DAILY."
  }
}

variable "resource_types" {
  description = "Specific AWS resource types to record. Empty means all supported."
  type        = list(string)
  default     = []
}

variable "enable_config_recorder" {
  description = "Enable the AWS Config recorder."
  type        = bool
  default     = true
}

variable "delivery_channel_snapshot_frequency" {
  description = "Snapshot delivery frequency."
  type        = string
  default     = "TwentyFour_Hours"

  validation {
    condition = contains([
      "One_Hour",
      "Three_Hours",
      "Six_Hours",
      "Twelve_Hours",
      "TwentyFour_Hours"
    ], var.delivery_channel_snapshot_frequency)
    error_message = "Invalid snapshot delivery frequency."
  }
}

variable "tags" {
  description = "Tags to apply to supported resources."
  type        = map(string)
  default     = {}
}
