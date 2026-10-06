package lab.gw;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.reactive.server.WebTestClient;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureWebTestClient
class GatewayTest {
    @Autowired WebTestClient client;

    @Test
    void apiKeyRoutesToPremium() {
        client.get().uri("/orders/1").header("X-Api-Key", "premium-demo-key").exchange()
            .expectStatus().isOk().expectBody(String.class).isEqualTo("premium-orders");
    }

    @Test
    void defaultRoutesToStandardWithCorrelationHeader() {
        client.get().uri("/orders/1").exchange()
            .expectStatus().isOk()
            .expectHeader().value("X-Correlation-Id", v -> assertTrue(v.startsWith("std-")))
            .expectBody(String.class).isEqualTo("standard-orders");
    }
}
