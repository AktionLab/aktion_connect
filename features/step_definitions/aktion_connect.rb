Given /^a config directory is setup$/ do
  FileUtils.mkdir_p('config')
  config_dir = File.expand_path(File.join(__FILE__,'..','..','..','config'))
  Aktion::Connect.config_dir = config_dir
end

Given /^there is a service$/ do
  unless defined? TestService
    class TestService
      def connect(config)
      end
    end
  end
  TestService.stub(:connect)
end

Given /^the service has been configured$/ do
  Aktion::Connect.register_service('test') do |config|
    TestService.connect(config)
  end
end

Given /^the service has a default config$/ do
  File.write('test.defaults.conf', <<-CONF)
    development:
      user: 'dev_user'
      pass: 'dev_pass'
  CONF
end

When /^a connection to the service is requested$/ do
  Aktion::Connect.connect('test')
end

Then /^the service receives a connection request$/ do
  TestService.should have_received(:connect)
end
