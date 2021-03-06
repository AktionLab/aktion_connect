# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aktion_connect/version'

Gem::Specification.new do |spec|
  spec.name          = "aktion_connect"
  spec.version       = AktionConnect::VERSION
  spec.authors       = ["Chris Boertien"]
  spec.email         = ["chris@aktionlab.com"]
  spec.summary       = %q{Provide a simple connection interface to multiple services.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~> 4.1.0'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'byebug'
end
