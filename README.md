# AktionConnect

Provides an interface for defining service connections. Once defined connections can
be managed through the interface.

## Installation

Add this line to your application's Gemfile:

    gem 'aktion_connect'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install aktion_connect

## Usage

### Defining a service

Here we show an example of setting up a simple redis connection.

First define the service for redis and set the config directory.

    Aktion::Connect.config_dir = 'config'
    
    Aktion::Connect.register_service('redis') do |config|
      Redis.new(config)
    end

Next define a defaults config file, this file is useful to check into
version control to supply a set of defaults that will work in most dev
environments.

    # config/redis.defaults.yml
    development:
      host: 'localhost'
      port: 6379
      db: 0
    test:
      host: 'localhost'
      port: 6379
      db: 1

Additionally, an override config can be specified to alter part or all
of the default configuration. For example if a developer was using port
6380 for their redis they can override the port only.

    # config/redis.yml
    development:
      port: 6380
    test:
      port: 6380

It is best to add this to any ignore files so that overrides can be managed
locally.

### Using a service

Once a service has been defined, establishing a connection is as simple as calling
connect and providing the service name.

    Aktion::Connect.connect('redis')

The returned connection will be exactly what was returned from the block when
defining the service. Calling connect on the same service more than once will
return the same connection by default. In order to get a new connection
use the `new_connection` method.

    Aktion::Connect.new_connection('redis')

Calling this method will not change the returned connection from `connect`.

In order to close the stored connection simply call close with the service
name. This will attempt to shutdown the underlying service as well as
causing a future call to `connect` to create a new connection.

    Aktion::Connect.close('redis')

By default, the underlying service must respond to close in order to be
properly closed with this method. Otherwise the close method must be
specified when registering the service, or you can close it manually before
calling close.

    Aktion::Connect.register_service('redis', close_method: 'quit') do |config|
      Redis.new config
    end

    Aktion::Connect.close('redis')

## Contributing

1. Fork it ( http://github.com/<my-github-username>/aktion_connect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
