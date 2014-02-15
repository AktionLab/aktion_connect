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
  @test_connection.stub(:close)
end

Given /^the service has been configured$/ do
  Aktion::Connect.register_service('test_service') do |config|
    TestService.connect(config)
  end
end

Given /^the service has been configured without a block$/ do
  Aktion::Connect.register_service('test_service')
end

Given /^the service has been configured with a "([^"]+)" environment$/ do |env|
  Aktion::Connect.env = env
  step "the service has been configured"
end

When /^a connection to the service is requested$/ do
  Aktion::Connect.connect('test_service')
end

Then /^the service receives a connection request$/ do
  TestService.should have_received(:connect)
end
