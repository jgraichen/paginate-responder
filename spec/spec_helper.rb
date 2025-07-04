# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

# Workaround for older Rails versions not explicitly requiring logger
require 'logger'

# Configure Rails
ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'active_support'
require 'action_controller'
require 'active_record'

require 'rspec'

require 'responders'

GEM = ENV.fetch('GEM', 'will_paginate')

case GEM
  when 'will_paginate'
    require 'will_paginate/array'
    require 'will_paginate/active_record'
  when 'kaminari'
    require 'kaminari'
    require 'kaminari/models/array_extension'

    Kaminari::Hooks.init if defined?(Kaminari::Hooks)

    Kaminari.configure do |config|
      config.default_per_page = 50
      config.max_per_page = 50
    end
  when 'pagy'
    require 'pagy'
    require 'pagy/extras/array'
    require 'pagy/extras/items'

    TestController.include(Pagy::Backend)

    Pagy::VARS[:items] = 50
    Pagy::VARS[:max_items] = 50
end

require 'paginate-responder'

Dir[File.expand_path('spec/support/**/*.rb')].sort.each {|f| require f }

RSpec.configure do |config|
  config.order = 'random'
  config.include SetupAndTeardownAdapter
  config.include ActionController::TestCase::Behavior
end
