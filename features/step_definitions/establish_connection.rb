After do
  FileUtils.rm_r('config') if Dir.exists?('config')
  Aktion::Connect.reset
end

Given /^a config directory is setup$/ do
  FileUtils.mkdir_p('config')
  config_dir = File.expand_path(File.join(__FILE__,'..','..','..','config'))
  Aktion::Connect.config_dir = config_dir
end

Given /^there is a service$/ do
  stub_const("TestService", Class.new)
  @test_connection = TestService.new
  TestService.stub(:connect).and_return(@test_connection)
  @test_connection.stub(:disconnect)
end

Given /^the service has been configured$/ do
  Aktion::Connect.register_service('test_service')
end

Given /^the service has been configured with open as a connect method$/ do
  TestService.unstub(:connect)
  # Need to define this to override the private method
  TestService.class_eval do
    def self.open(config)
      new
    end
  end
  TestService.stub(:open)

  Aktion::Connect.register_service('test_service', connect_method: 'open')
end

Given /^the service has been configured with a block to connect with$/ do
  Aktion::Connect.register_service('test_service') do |config|
    TestService.connect config
  end
end

Given /^the service has been configured with a "([^"]+)" environment$/ do |env|
  Aktion::Connect.env = env
  step "the service has been configured"
end

Given /^the service has been configured with a different service name$/ do
  Aktion::Connect.register_service('test', service_class: TestService)
end

When /^a connection to the service is requested$/ do
  Aktion::Connect.connect('test_service')
end

When /^a connection to the service is requested twice$/ do
  @connection1 = Aktion::Connect.connect('test_service')
  @connection2 = Aktion::Connect.connect('test_service')
end

When /^a connection to the service is requested with a different service name$/ do
  Aktion::Connect.connect('test')
end

Then /^the service receives a connection request$/ do
  TestService.should have_received(:connect)
end

Then /^the service receives a connection request to open$/ do
  TestService.should have_received(:open)
end

Then /^the service receives a connection request once$/ do
  TestService.should have_received(:connect).once
end

Then /^the request returns the same connection$/ do
  @connection1.should equal @connection2
end
