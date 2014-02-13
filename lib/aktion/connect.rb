require 'pathname'

module Aktion
  class Connect
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
      @services[name] = Service.new(name, 'development', config_dir, &block)
    end

    def self.connect(name)
      @services[name].connect
    end

    class Service
      attr_reader :name, :env, :config_dir, :config

      def initialize(name, env, config_dir, &block)
        @name, @env, @config_dir, @proc = name, env, config_dir, block
        load_config
      end

      def connect
        @proc.call(@config)
      end

      private

      def load_config
        @config = default_config.merge(override_config)
      end

      def default_config
        if File.exists? config_dir.join("#{name}.example.yml")
          config_dir.join("#{name}.defaults.yml")[env]
        else
          {}
        end
      end

      def override_config
        if File.exists? config_dir.join("#{name}.yml")
          config_dir.join("#{name}.yml")
        else
          {}
        end
      end
    end
  end
end