require 'pathname'
require 'active_support/inflector'

module Aktion
  class Connect
    class << self
      attr_accessor :env
    end

    def self.reset
      @services = {}
      @connections = {}
      @config_dir = nil
      @env = nil
    end
    reset

    def self.config_dir
      @config_dir
    end

    def self.config_dir=(config_dir)
      @config_dir = Pathname.new(config_dir)
    end

    def self.configs
      @configs
    end

    def self.register_service(name, opts={}, &block)
      @services[name] = Service.new(name, env, config_dir, opts, &block)
    end

    def self.connect(name)
      @services[name].connect
    end

    def self.disconnect(name)
      @services[name].disconnect
    end

    class Service
      attr_reader :name, :env, :config_dir, :config

      DEFAULT_OPTS = {
        disconnect_method: :disconnect,
        connect_method: :connect
      }

      def initialize(name, env, config_dir, opts={}, &block)
        @name       = name
        @env        = env
        @config_dir = config_dir
        @opts       = DEFAULT_OPTS.merge(opts)
        @proc       = block
        @config     = default_config.merge(override_config)
      end

      def connect
        @connection ||=
          unless @proc.nil?
            @proc.call(@config)
          else
            service_class.public_send(@opts[:connect_method], @config)
          end
      end

      def disconnect
        @connection.send(@opts[:disconnect_method])
      end

      private

      def service_class
        @opts[:service_class] ||= name.camelize.constantize
      end

      def default_config
        load_config("#{name}.defaults.yml")
      end

      def override_config
        load_config("#{name}.yml")
      end

      def load_config(filename)
        if File.exists? config_dir.join(filename)
          if env
            YAML.load_file(config_dir.join(filename))[env]
          else
            YAML.load_file(config_dir.join(filename))
          end
        else
          {}
        end
      end
    end
  end
end
