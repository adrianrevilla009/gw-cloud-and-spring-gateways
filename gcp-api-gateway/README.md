# gcp-api-gateway

Terraform for a Google Cloud API Gateway driven by an OpenAPI 2.0 document with API-key security.

## Goal
Show the three GCP API Gateway resources (API, API config, gateway) and how the OpenAPI file defines routes, security and the backend.

## Run it
```
terraform init -backend=false && terraform validate
```
Expected: `Success! The configuration is valid.` This was run here with `google-beta` 6.8.0; no credentials are needed.

Not run end to end: it was never planned or applied, so the gateway was not tested against a real project or backend. If you apply it, finish with `terraform destroy`. Cost note: API Gateway is billed per call after a monthly free allowance.

## What it proves
- `main.tf` chains `google_api_gateway_api`, `google_api_gateway_api_config` (embedding `openapi.yaml` through `filebase64`) and `google_api_gateway_gateway`.
- `openapi.yaml` protects `GET /orders` with an `api_key` passed as the `key` query parameter.
- The `x-google-backend` extension sends traffic to a Cloud Run address with `APPEND_PATH_TO_ADDRESS`.
- `create_before_destroy` on the config lets a new version replace the old one without downtime.

## Trade-offs
- `project_id` defaults to `orders-lab-placeholder` and the backend URL is a made-up Cloud Run host, so both must be replaced before any real use.
- The config id is fixed (`orders-config-v1`); a new revision needs a new id.
- API keys identify callers but are weak authentication; the API must also be enabled for the key in the project.

## When not to use it
- When you need usage plans or quotas per consumer in one place; AWS and Apigee model that more directly.
- For richer policy logic such as transformations, which this gateway does not offer.
