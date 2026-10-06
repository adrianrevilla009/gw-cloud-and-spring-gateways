# aws-api-gateway

Terraform for an API Gateway REST API with a Lambda token authorizer, a required API key and a usage plan.

## Goal
Show how an authorizer, an API key and a usage plan fit together on a REST API, with the AWS provider pinned to 5.72.1.

## Run it
```
terraform init -backend=false && terraform validate
```
Expected: `Success! The configuration is valid.` This was run here. It needs the provider download but no credentials.

Not run end to end: the config was never planned or applied. Do not apply it to a real account; if you experiment, use LocalStack and finish with `terraform destroy`.

Cost note: REST API calls are billed per request (free tier in the first year, then about 3.50 USD per million); the mock integration adds no other cost.

## What it proves
- `main.tf` wires the plan to the stage (`api_stages`) and the key to the plan (`aws_api_gateway_usage_plan_key`).
- `GET /orders` uses `authorization = "CUSTOM"` with a TOKEN authorizer reading the `Authorization` header (cached 300 s) and `api_key_required = true`.
- The usage plan allows 10 requests per second, burst 20, and 1000 per day.
- The deployment `triggers` hash forces a redeploy when the method or integration changes.

## Trade-offs
- The authorizer Lambda is not included; `variables.tf` defaults to a dummy ARN, and no `aws_lambda_permission` exists, so a real Lambda would need one.
- The integration is a MOCK that returns 200, so no real backend is involved.
- Usage plan limits are best-effort throttling, not a security boundary.

## When not to use it
- For JWT-only APIs, where an HTTP API (v2) is cheaper and simpler.
- When you need strictly accurate per-tenant rate limits.
