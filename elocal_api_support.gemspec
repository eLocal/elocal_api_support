# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elocal_api_support/version'

Gem::Specification.new do |spec|
  spec.name          = "elocal_api_support"
  spec.version       = ElocalApiSupport::VERSION
  spec.authors       = ["Rob Di Marco"]
  spec.email         = ["rob@elocal.com"]
  spec.description   = %q{Utilities for controllers when creating a JSON API}
  spec.summary       = %q{Utilities for controllers when creating a JSON API}
  spec.homepage      = "http://github.com/elocal/elocal_api_support"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 4.0.0'
  spec.add_dependency 'actionpack', '>= 4.0.0'
  spec.add_dependency 'activerecord', '>= 4.0.0'
  spec.add_dependency 'responders', '~> 2.0'
  spec.add_dependency 'kaminari'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec-rails", '>= 3.5.0.beta4'
  spec.add_development_dependency "rake"
end
