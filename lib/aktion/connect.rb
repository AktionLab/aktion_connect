require 'pathname'

require 'byebug'

module Aktion
  class Connect
    class << self
      attr_accessor :env
    end

    def self.config_dir
      @config_dir
    end

    def self.config_dir=(config_dir)
      @config_dir = Pathname.new(config_dir)
    end

    def self.configs
      @configs
    end

    def self.register_service(name, &block)
      @services ||= {}
      @services[name] = Service.new(name, env, config_dir, &block)
    end

    def self.connect(name)
      @services[name].connect
    end

    class Service
      attr_reader :name, :env, :config_dir, :config

      def initialize(name, env, config_dir, &block)
        @name, @env, @config_dir, @proc = name, env, config_dir, block
        @config = default_config.merge(override_config)
      end

      def connect
        @proc.call(@config)
      end

      private

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
