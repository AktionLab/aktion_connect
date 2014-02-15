Given /^the service has a default config$/ do
  File.write('config/test_service.defaults.yml', <<-YML)
    user: 'user'
    pass: 'pass'
  YML
end

Given /^the service has a default config with a different service name$/ do
  File.write('config/test.defaults.yml', <<-YML)
    user: 'user'
    pass: 'pass'
  YML
end

Given /^the service has an override config$/ do
  File.write("config/test_service.yml", <<-YML)
    user: 'ouser'
    pass: 'opass'
  YML
end

Given /^the service has a partial override config$/ do
  File.write("config/test_service.yml", <<-YML)
    user: 'ouser'
  YML
end

Given /^the service has a default config with environments$/ do
  File.write('config/test_service.defaults.yml', <<-YML)
    development:
      user: 'dev_user'
      pass: 'dev_pass'
    test:
      user: 'test_user'
      pass: 'test_pass'
  YML
end

Given /^the service has an override config with environments$/ do
  File.write('config/test_service.yml', <<-YML)
    development:
      user: 'odev_user'
      pass: 'odev_pass'
    test:
      user: 'otest_user'
      pass: 'otest_pass'
  YML
end

Given /^the service has a partial override config with environments$/ do
  File.write('config/test_service.yml', <<-YML)
    development:
      user: 'odev_user'
    test:
      user: 'otest_user'
  YML
end

Then /^the service receives a connection request with the default config$/ do
  TestService.should have_received(:connect).with({'user'=>'user','pass'=>'pass'})
end

Then /^the service receives a connection request with the override config$/ do
  TestService.should have_received(:connect).with({'user'=>'ouser','pass'=>'opass'})
end

Then /^the service receives a connection request with the partial override config$/ do
  TestService.should have_received(:connect).with({'user'=>'ouser','pass'=>'pass'})
end

Then /^the service receives a connection request with the "([^"]+)" default config$/ do |env|
  if env == 'development'
    TestService.should have_received(:connect).with({'user'=>'dev_user','pass'=>'dev_pass'})
  elsif env == 'test'
    TestService.should have_received(:connect).with({'user'=>'test_user','pass'=>'test_pass'})
  else
    raise 'unknown env'
  end
end

Then /^the service receives a connection request with the "([^"]+)" override config$/ do |env|
  if env == 'development'
    TestService.should have_received(:connect).with({'user'=>'odev_user','pass'=>'odev_pass'})
  elsif env == 'test'
    TestService.should have_received(:connect).with({'user'=>'otest_user','pass'=>'otest_pass'})
  else
    raise 'unknown env'
  end
end

Then /^the service receives a connection request with the "([^"]+)" partial override config$/ do |env|
  if env == 'development'
    TestService.should have_received(:connect).with({'user'=>'odev_user','pass'=>'dev_pass'})
  elsif env == 'test'
    TestService.should have_received(:connect).with({'user'=>'otest_user','pass'=>'test_pass'})
  else
    raise 'unknown env'
  end
end
