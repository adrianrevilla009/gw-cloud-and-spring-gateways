variable "authorizer_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Lambda authorizer function"
  default     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:000000000000:function:authorizer/invocations"
}
