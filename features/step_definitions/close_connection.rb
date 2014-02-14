When /^the connection is closed$/ do
  Aktion::Connect.close('test')
end

Then /^the service receives a close connection$/ do
  @test_connection.should have_received(:close)
end
