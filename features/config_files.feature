Feature: Allow for default and override config files
  In order to allow projects to provide a sensible
  set of defaults while allowing individual overrides
  a default config file may be provided with the a
  local override.

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

  Scenario: Establish a connection using a partial override config
    Given the service has a default config
    And the service has a partial override config
    And the service has been configured
    When a connection to the service is requested
    Then the service receives a connection request with the partial override config

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

  Scenario: Establish a connection using an override with environment
    Given the service has a default config with environments
    And the service has a partial override config with environments
    And the service has been configured with a "test" environment
    When a connection to the service is requested
    Then the service receives a connection request with the "test" partial override config
