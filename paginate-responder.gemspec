# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paginate-responder/version'

Gem::Specification.new do |gem|
  gem.name          = 'paginate-responder'
  gem.version       = PaginateResponder::VERSION
  gem.authors       = ['Jan Graichen']
  gem.email         = ['jg@altimos.de']
  gem.description   = 'A Rails pagination responder with link header support.'
  gem.summary       = 'A Rails pagination responder with link header support.'
  gem.homepage      = 'https://github.com/jgraichen/paginate-responder'
  gem.license       = 'MIT'

  gem.metadata = {
    'rubygems_mfa_required' => 'true',
  }

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map {|f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.5.0'

  gem.add_dependency 'rack-link_headers', '>= 2.2'
  gem.add_dependency 'responders'
end
