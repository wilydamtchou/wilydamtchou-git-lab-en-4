package com.example.demopipeline;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @SuppressFBWarnings("NP_NONNULL_RETURN_VIOLATION")
    @GetMapping("/hello")
    public String hello() {
        return "Hello CI/CD";
    }
}
