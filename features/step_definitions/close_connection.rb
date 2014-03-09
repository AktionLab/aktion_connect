Given /^the service has been configured with a close method$/ do
  @test_connection.unstub(:disconnect)
  @test_connection.stub(:close)

  Aktion::Connect.register_service('test_service', disconnect_method: 'close') do |config|
    TestService.connect(config)
  end
end

When /^the connection is closed$/ do
  Aktion::Connect.disconnect('test_service')
end

Then /^the service receives a close connection$/ do
  @test_connection.should have_received(:close)
end

Then /^the service receives a disconnect connection$/ do
  @test_connection.should have_received(:disconnect)
end
