# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paginate-responder/version'

Gem::Specification.new do |gem|
  gem.name          = "paginate-responder"
  gem.version       = PaginateResponder::VERSION
  gem.authors       = ['Jan Graichen']
  gem.email         = ['jg@altimos.de']
  gem.description   = %q{A Rails pagination responder with link header support.}
  gem.summary       = %q{A Rails pagination responder with link header support.}
  gem.homepage      = "https://github.com/jgraichen/paginate-responder"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rack-link_headers', '>= 2.2'

  gem.add_development_dependency 'actionpack', '>= 3.2.0'
  gem.add_development_dependency 'activerecord', '>= 3.2.0'
  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'kaminari'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-byebug'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'responders'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'will_paginate'
  gem.add_development_dependency 'test-unit'
end
