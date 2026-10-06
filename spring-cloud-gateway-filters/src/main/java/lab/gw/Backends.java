package lab.gw;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/** Stand-in backends so the lab runs without any other service. */
@RestController
class Backends {
    @GetMapping("/premium")
    String premium() { return "premium-orders"; }

    @GetMapping("/standard")
    String standard() { return "standard-orders"; }
}
