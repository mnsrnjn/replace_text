
variable "aws_region" {
  description = "The location/region where the resource is created"
  type        = string
  default     = "eu-west-1"
}

variable "access_key" {
  description = "access key for logging in to account"
  type        = string
}

variable "secret_key" {
  description = "secret ey to login to aws account to create resource"
  type        = string
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = "lambda_for_textreplace"
}

variable "api_name" {
  description = "A unique name for your api gateway"
  type        = string
  default     = "replace-word-api"
}

variable "stage" {
  description = "Name of the stage to which deployed"
  type        = string
  default     = "replacetext"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {
    "usage"      = "assignment"
    "createdby"  = "manas"
  }
}

