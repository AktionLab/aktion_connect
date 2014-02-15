Feature: Connect to a service

  Background:
    Given there is a service
    And a config directory is setup

  Scenario: Establish a connection using a default connect method
    Given the service has a default config
    And the service has been configured
    When a connection to the service is requested
    Then the service receives a connection request

  Scenario: Establish a connection using a custom connect method
    Given the service has a default config
    And the service has been configured with open as a connect method
    When a connection to the service is requested
    Then the service receives a connection request to open

  Scenario: Establish a connection using a block
    Given the service has a default config
    And the service has been configured with a block to connect with
    When a connection to the service is requested
    Then the service receives a connection request

  Scenario: Establish a connection using a name that doesnt match the class
    Given the service has a default config with a different service name
    And the service has been configured with a different service name
    When a connection to the service is requested with a different service name
    Then the service receives a connection request
