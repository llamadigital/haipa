# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'haipa/version'

Gem::Specification.new do |spec|
  spec.name          = 'haipa'
  spec.version       = Haipa::VERSION
  spec.authors       = ['Jon Doveston']
  spec.email         = ['jon@doveston.me.uk']
  spec.description   = %q{HAL hypermedia client}
  spec.summary       = %q{HAL hypermedia client}
  spec.homepage      = 'https://github.com/hatoishi/haipa'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', '~> 0.8'
  spec.add_runtime_dependency 'hashie', '~> 2.0.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.13.0'
end
