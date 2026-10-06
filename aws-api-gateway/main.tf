terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

# Point at LocalStack (or a real region) via your own environment; nothing here holds credentials.
provider "aws" {
  region = "eu-west-1"
}

resource "aws_api_gateway_rest_api" "orders" {
  name = "orders-api"
}

resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.orders.id
  parent_id   = aws_api_gateway_rest_api.orders.root_resource_id
  path_part   = "orders"
}

# Lambda authorizer (TOKEN type). The function itself is out of scope: pass its invoke ARN.
resource "aws_api_gateway_authorizer" "token" {
  name                             = "orders-token-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.orders.id
  type                             = "TOKEN"
  authorizer_uri                   = var.authorizer_invoke_arn
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 300
}

resource "aws_api_gateway_method" "get_orders" {
  rest_api_id      = aws_api_gateway_rest_api.orders.id
  resource_id      = aws_api_gateway_resource.orders.id
  http_method      = "GET"
  authorization    = "CUSTOM"
  authorizer_id    = aws_api_gateway_authorizer.token.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "mock" {
  rest_api_id       = aws_api_gateway_rest_api.orders.id
  resource_id       = aws_api_gateway_resource.orders.id
  http_method       = aws_api_gateway_method.get_orders.http_method
  type              = "MOCK"
  request_templates = { "application/json" = "{\"statusCode\": 200}" }
}

resource "aws_api_gateway_deployment" "v1" {
  rest_api_id = aws_api_gateway_rest_api.orders.id
  triggers = {
    redeploy = sha1(jsonencode([aws_api_gateway_method.get_orders, aws_api_gateway_integration.mock]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.orders.id
  deployment_id = aws_api_gateway_deployment.v1.id
  stage_name    = "prod"
}

resource "aws_api_gateway_usage_plan" "basic" {
  name = "basic"
  throttle_settings {
    rate_limit  = 10
    burst_limit = 20
  }
  quota_settings {
    limit  = 1000
    period = "DAY"
  }
  api_stages {
    api_id = aws_api_gateway_rest_api.orders.id
    stage  = aws_api_gateway_stage.prod.stage_name
  }
}

resource "aws_api_gateway_api_key" "demo" {
  name = "demo-key"
}

resource "aws_api_gateway_usage_plan_key" "demo" {
  key_id        = aws_api_gateway_api_key.demo.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.basic.id
}
