package lab.gw;

import java.util.List;
import java.util.function.Predicate;
import org.springframework.cloud.gateway.handler.predicate.AbstractRoutePredicateFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

/** Custom predicate: route matches only when X-Api-Key equals the configured key. */
@Component
public class ApiKeyRoutePredicateFactory extends AbstractRoutePredicateFactory<ApiKeyRoutePredicateFactory.Config> {

    public ApiKeyRoutePredicateFactory() {
        super(Config.class);
    }

    @Override
    public List<String> shortcutFieldOrder() {
        return List.of("key");
    }

    @Override
    public Predicate<ServerWebExchange> apply(Config config) {
        return exchange -> config.getKey().equals(exchange.getRequest().getHeaders().getFirst("X-Api-Key"));
    }

    public static class Config {
        private String key;

        public String getKey() { return key; }
        public void setKey(String key) { this.key = key; }
    }
}
