Feature: Hello endpoint
  Scenario: Call /hello
    Given the application is running
    When I call GET /hello
    Then the response should be "Hello CI/CD"
