# spring-cloud-gateway-filters

A Spring Cloud Gateway app with a custom route predicate, a custom gateway filter and two stand-in backends, covered by a test.

## Goal
Show how to extend Spring Cloud Gateway with your own predicate and filter factory, and how route order decides which backend a request reaches.

## Run it
```
mvn -q test
```
Expected: `GatewayTest` passes (2 tests, no failures); the log shows the gateway starting on a random Netty port. It was run here and passed.

## What it proves
- `ApiKeyRoutePredicateFactory.java` matches a route only when the `X-Api-Key` header equals the configured key, so `GET /orders/1` with `premium-demo-key` returns `premium-orders`.
- Without the key the request falls through to the second route in `application.yml` and returns `standard-orders`.
- `OrderIdHeaderGatewayFilterFactory.java` sets `X-Correlation-Id` on the downstream request and the response, using the route's prefix (`std-` or `prem-`) plus a UUID when the caller sent none; the test checks the `std-` prefix.

## Trade-offs
- The API key is a literal in `application.yml`; real keys belong in a secret store or an identity provider.
- The backends are `forward:` routes to controllers in `Backends.java` inside the same app, so no proxying over the network is exercised.
- The test asserts the correlation prefix only for the standard route, not the premium one.

## When not to use it
- When a managed gateway (see the sibling folders) already gives you keys, quotas and auth.
- When you only need to add a static header: the built-in `AddRequestHeader` filter is enough.
