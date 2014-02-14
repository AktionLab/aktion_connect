Feature: Connect to a confgiured service

  Background:
    Given there is a service
    And a config directory is setup

  Scenario: Establish a connection using a default config
    Given the service has a default config
    And the service has been configured
    When a connection to the service is requested
    Then the service receives a connection request with the default config

  Scenario: Establish a connection using an override config
    Given the service has a default config
    And the service has an override config
    And the service has been configured
    When a connection to the service is requested
    Then the service receives a connection request with the override config

  Scenario: Establish a connection using an environment
    Given the service has a default config with environments
    And the service has been configured with a "test" environment
    When a connection to the service is requested
    Then the service receives a connection request with the "test" default config

  Scenario: Establish a connection using an override with environment
    Given the service has a default config with environments
    And the service has an override config with environments
    And the service has been configured with a "test" environment
    When a connection to the service is requested
    Then the service receives a connection request with the "test" override config
