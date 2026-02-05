package com.example.demopipeline.cucumber;

import io.cucumber.java.en.*;
import org.springframework.boot.test.web.client.TestRestTemplate;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class StepDefinitions {

    private String response;

    @Given("the application is running")
    public void the_application_is_running() {
        // Rien à faire ici, l'application est supposée tourner
    }

    @When("I call GET /hello")
    public void i_call_get_hello() {
        TestRestTemplate rest = new TestRestTemplate();
        response = rest.getForObject("http://localhost:8080/hello", String.class);
    }

    @Then("the response should be {string}")
    public void the_response_should_be(String expected) {
        assertEquals(expected, response);
    }
}
