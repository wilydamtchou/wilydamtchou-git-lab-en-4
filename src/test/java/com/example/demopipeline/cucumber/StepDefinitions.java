package com.example.demopipeline.cucumber;

import io.cucumber.java.en.*;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;

public class StepDefinitions {

    private String response;
    private ResponseEntity<String> responseEntity;
    private TestRestTemplate restTemplate;
    private static final String BASE_URL = "http://localhost:8080";

    public StepDefinitions() {
        this.restTemplate = new TestRestTemplate();
    }

    @Given("the application is running")
    public void the_application_is_running() {
        // Verify application is accessible
        try {
            ResponseEntity<String> response = restTemplate.getForEntity(BASE_URL + "/hello", String.class);
            assertNotNull(response);
        } catch (Exception e) {
            fail("Application is not running on " + BASE_URL);
        }
    }

    @When("I call GET /hello")
    public void i_call_get_hello() {
        try {
            responseEntity = restTemplate.getForEntity(BASE_URL + "/hello", String.class);
            response = responseEntity.getBody();
            assertNotNull(response, "Response body should not be null");
        } catch (Exception e) {
            fail("Failed to call GET /hello: " + e.getMessage());
        }
    }

    @Then("the response should be {string}")
    public void the_response_should_be(String expected) {
        assertNotNull(response, "Response should not be null");
        assertEquals(expected, response.trim(),
            "Response should match expected: '" + expected + "' but got: '" + response + "'");
    }
}


