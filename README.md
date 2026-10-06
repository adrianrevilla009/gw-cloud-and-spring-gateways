# gw-cloud-and-spring-gateways

One Orders API fronted by a Spring Cloud Gateway with custom filters and predicates, and by the managed gateways of AWS, Azure and GCP, so you can compare how each one expresses auth, throttling and routing.

## What is inside

| Folder | What it shows | Run |
| --- | --- | --- |
| [`spring-cloud-gateway-filters`](./spring-cloud-gateway-filters) | A custom route predicate (`ApiKey`) and a custom gateway filter (`OrderIdHeader`) with two routes | `mvn -q test` |
| [`aws-api-gateway`](./aws-api-gateway) | REST API with a Lambda token authorizer, required API key and a usage plan | `terraform init -backend=false && terraform validate` |
| [`azure-apim`](./azure-apim) | API Management (Consumption) with a rate-limit, JWT and header policy | `terraform init -backend=false && terraform validate` |
| [`gcp-api-gateway`](./gcp-api-gateway) | API Gateway driven by an OpenAPI 2.0 file with API-key security | `terraform init -backend=false && terraform validate` |
| [`apigee-awareness`](./apigee-awareness) | Short note on what Apigee adds; no code | `wc -w README.md` |

## Prerequisites

- Java 21 and Maven 3.8 or newer (Spring Boot 3.3.5, Spring Cloud 2023.0.3)
- Terraform 1.6 or newer (the providers are pinned in each folder)
- No cloud account is needed: nothing here is applied, and `terraform validate` needs no credentials

## How to read it

Start with `spring-cloud-gateway-filters`, the only folder that runs as a service, then read the three cloud folders side by side. The Terraform folders are validated offline only; none of them was planned or applied.
