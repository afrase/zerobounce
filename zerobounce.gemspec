# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zerobounce/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'zerobounce'
  spec.version       = Zerobounce::VERSION
  spec.authors       = ['Aaron Frase']
  spec.email         = ['afrase91@gmail.com']

  spec.summary       = 'A Ruby client for Zerobounce.net.'
  spec.description   = 'A Ruby client for Zerobounce.net.'
  spec.homepage      = 'https://github.com/afrase/zerobounce'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['yard.run'] = 'yri' # use "yard" to build full HTML docs.

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'faraday', '>= 0.14', '< 2.0'
  spec.add_dependency 'faraday_middleware', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.2.17'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.1'
  spec.add_development_dependency 'rubocop', '~> 1.15'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.3'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'yard', '~> 0.9.26'
end
