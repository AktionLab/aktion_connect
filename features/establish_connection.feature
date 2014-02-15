Feature: Connect to a service

  Background:
    Given there is a service
    And a config directory is setup

  Scenario: Establish a connection using a connect method by default
    Given the service has a default config
    And the service has been configured without a block
    When a connection to the service is requested
    Then the service receives a connection request
