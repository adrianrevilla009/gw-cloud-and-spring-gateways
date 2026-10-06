# apigee-awareness

A short written note on Google Apigee and what it adds beyond the gateways in the sibling folders. It contains no code.

## Goal
Explain when an API management platform like Apigee is worth considering compared with a plain gateway.

## Run it
```
wc -w README.md
```
Expected: a word count of the note. Nothing is executed or provisioned; no Apigee org was used, so none of the Apigee details below were tested here.

## What it proves
- The vocabulary: API proxy, flows (ProxyEndpoint and TargetEndpoint), XML policies such as SpikeArrest, Quota, VerifyAPIKey and OAuthV2, environments, API products, developer apps and the developer portal.
- API products bundle proxies with quotas and are what developers subscribe to, which is the main step up from the usage plans in `aws-api-gateway`.
- Analytics, monetization and a developer portal come with the platform instead of being extra pieces.

## Trade-offs
- Priced for enterprises, with a meaningful monthly floor, so it does not fit a free-tier lab and nothing is provisioned.
- Proxy bundles are XML and can be deployed with the Apigee Terraform resources and `apigeecli`, but local emulation is limited.
- The operating model is heavier than AWS API Gateway, Azure APIM Consumption or GCP API Gateway.

## When not to use it
- For small or internal APIs and single-team services, where a gateway filter or a managed gateway's usage plan is enough.
- Choose it only when you run an API program: external developers, products, monetization and governance across many teams.
