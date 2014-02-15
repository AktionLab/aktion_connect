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

### Registering a service

In order to use the interface to manage connections to services
they must first be registered. This will provide some necessary
information for interfacing with the underlying service.

By default register service assumes 3 conventions:
- The service class name is the caps-case version of the service name
  (ie. `some_service` becomes `SomeService`
- The service accepts a call to connect to establish a connection
- The service accepts a call to disconnect to drop a connection

All of these conventions can be overriden by supplying an options
hash as a second argument. Alternatively a block can be passed
to handle more complex connection scenarios.

The following examples will show a class definition folowed
by the service registration required to make it work.

#### Register a service using all defaults

    class SomeService
      def self.connect(config)
      end

      def disconnect
      end
    end

    Aktion::Connect.register_service('some_service')

#### Register a service that specifies a class name

    module Some
      class Service
        def self.connect(config)
        end

        def disconnect
        end
      end
    end

    Aktion::Connect.resgiter_service('some_service', service_class: Some::Service)

#### Register a service that uses different connect/disconnect methods

    class SomeService
      def self.open
      end

      def close
      end
    end

    Aktion::Connect.register_service('some_service', connect_method: 'open', disconnect_method: 'close')

#### Register a service that uses a block to handle connections

    class SomeService
      def connect(host, port)
      end

      def login(user, pass)
      end

      def disconnect
      end
    end

    Aktion::Connect.register_service('some_service') do |config|
      SomeService.new.tap do |service|
        service.connect(config[:host], config[:port])
        service.login(config[:user], config[:pass])
      end
    end

When using a block, it's important to note that the instance of the connected
service needs to be returned so the interface can manage it.

### Manage configuration files

In many projects configuration files use mostly standard settings for services
that they connect to, although in some cases it is necessary for each instance
of the project to contain local overrides for things such as username/password
or even host/ip/port when dealing with a deployment. For this reason this
library uses a combination of a defaults file that is meant to be checked into
version control, and a local override file that is ignored by version control
to allow customization as necessary.

The first step is specifying the directory where config files are located. This
needs to be done before registering any services. This can be a relative or
absolute path.

    Aktion::Connect.config_dir = 'config'

Once that is done all config files will be resolved with this setting and the
name of the service. Using our example services above, the two files that
are looked for are

    config/some_service.defaults.yml
    config/some_service.yml

In multi-environment projects it is necessary to set the environment before
declaring services which can be done similar to setting the `config_dir`.

    Aktion::Connect.env = 'development'

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
