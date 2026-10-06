package lab.gw;

import java.util.UUID;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.stereotype.Component;

/** Custom filter: adds a correlation header to the downstream request and the response. */
@Component
public class OrderIdHeaderGatewayFilterFactory extends AbstractGatewayFilterFactory<OrderIdHeaderGatewayFilterFactory.Config> {

    public static final String HEADER = "X-Correlation-Id";

    public OrderIdHeaderGatewayFilterFactory() {
        super(Config.class);
    }

    @Override
    public java.util.List<String> shortcutFieldOrder() {
        return java.util.List.of("prefix");
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            String id = exchange.getRequest().getHeaders().getFirst(HEADER);
            if (id == null) {
                id = config.getPrefix() + UUID.randomUUID();
            }
            var request = exchange.getRequest().mutate().header(HEADER, id).build();
            exchange.getResponse().getHeaders().set(HEADER, id);
            return chain.filter(exchange.mutate().request(request).build());
        };
    }

    public static class Config {
        private String prefix = "";

        public String getPrefix() { return prefix; }
        public void setPrefix(String prefix) { this.prefix = prefix; }
    }
}
