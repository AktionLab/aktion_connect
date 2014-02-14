Given /^the service has been configured with a disconnect close method$/ do
  @test_connection.unstub(:close)
  @test_connection.stub(:disconnect)

  Aktion::Connect.register_service('test', close_method: 'disconnect') do |config|
    TestService.connect(config)
  end
end

When /^the connection is closed$/ do
  Aktion::Connect.close('test')
end

Then /^the service receives a close connection$/ do
  @test_connection.should have_received(:close)
end

Then /^the service receives a disconnect connection$/ do
  @test_connection.should have_received(:disconnect)
end
