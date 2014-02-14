Feature: Close a connection
  In order to manage connections,
  a developer needs to be able to close the connection.

  Background:
    Given there is a service
    And a config directory is setup
    And the service has a default config

  Scenario: Close a connection to a service that has a close method
    Given the service has been configured
    When a connection to the service is requested
    And the connection is closed
    Then the service receives a close connection
