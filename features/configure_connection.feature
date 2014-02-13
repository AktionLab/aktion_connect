Feature: Connect to a confgiured service

  Scenario: Establish a connection to a configured service using a default config
    Given there is a service
    And a config directory is setup
    And the service has been configured
    And the service has a default config
    When a connection to the service is requested
    Then the service receives a connection request
