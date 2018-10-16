# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assumer/version'

Gem::Specification.new do |spec|
  spec.name          = 'assumer'
  spec.version       = Assumer::VERSION
  spec.authors       = ['Brandon Sherman']
  spec.email         = ['mechcozmo@gmail.com']

  spec.summary       = 'This gem provides the functionality to Assume Role in AWS'
  spec.description   = 'Allows for single or double-jumps through AWS accounts in order to assume a role in a target account'
  spec.homepage      = 'https://github.com/devsecops/assumer'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables.reject! { |f| f == '.rubocop.yml' }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  # Requires Ruby 2.1 or higher; 2.0 is buggy
  spec.required_ruby_version = '>= 2.1'
  spec.add_dependency 'aws-sdk-core', '~> 3'
  spec.add_dependency 'pry', '~>0'
  spec.add_dependency 'trollop', '2.1.2'
end
