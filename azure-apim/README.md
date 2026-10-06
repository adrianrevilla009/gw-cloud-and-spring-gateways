# azure-apim

Terraform for an Azure API Management instance on the Consumption tier, with one API and an XML policy.

## Goal
Show how APIM policies express throttling, token validation and header handling, and how Terraform attaches a policy file to an API.

## Run it
```
terraform init -backend=false && terraform validate
```
Expected: `Success! The configuration is valid.` This was run here with `azurerm` 3.116.0; no credentials are needed.

Not run end to end: it was never planned or applied, and the policy was not exercised against a live APIM instance. If you apply it yourself, finish with `terraform destroy`. Cost note: the Consumption tier is pay per call with no idle cost.

## What it proves
- `main.tf` creates the resource group, the `Consumption_0` service, an `orders` API requiring a subscription key, and loads `policy.xml` with `file()`.
- `policy.xml` limits each subscription to 10 calls per 60 seconds with `rate-limit-by-key`.
- It requires a JWT via `validate-jwt`, adds `X-Correlation-Id` when absent, and removes `X-Powered-By` from responses.

## Trade-offs
- `validate-jwt` points at the generic Microsoft `common` OpenID configuration, with no audience or issuer check, so any Entra-issued token would pass; a real setup needs its own tenant and claims.
- The backend is `https://httpbin.org`, a public echo service, and the publisher email is `lab@example.com`.
- Provisioning APIM can take several minutes and the names (`apim-orders-lab`) must be globally unique.

## When not to use it
- When you need a gateway you can run locally; APIM has no real local emulator.
- For a single internal API where a simple reverse proxy covers throttling and auth.
