# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef-analytics/version'

Gem::Specification.new do |spec|
  spec.name          = 'chef-analytics'
  spec.version       = ChefAnalytics::VERSION
  spec.authors       = ['James Casey']
  spec.email         = ['james@getchef.com']
  spec.description   = 'A Chef analytics API client with minimal dependencies'
  spec.summary       = 'A Chef analytics API client in Ruby'
  spec.homepage      = 'https://github.com/opscode/chef-analytics-api'
  spec.license       = 'Apache 2.0'

  spec.required_ruby_version = '>= 1.9'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'chef'
  spec.add_dependency 'mixlib-config'
end
