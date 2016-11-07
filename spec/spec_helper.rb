require 'rubygems'
require 'bundler/setup'

# Configure Rails
ENV['RAILS_ENV'] = 'test'

require 'rails'
require 'active_support'
require 'action_controller'
require 'active_record'

require 'rspec'

require 'responders'

require 'paginate-responder'

require 'pry'
require 'pry-byebug'

Dir[File.expand_path('spec/support/**/*.rb')].each {|f| require f }

$gem = ENV['GEM'].to_s
$gem = 'will_paginate' if $gem.empty?

case $gem
  when 'will_paginate'
    require 'will_paginate/array'
    require 'will_paginate/active_record'
  when 'kaminari'
    require 'kaminari'
    require 'kaminari/models/array_extension'

    Kaminari::Hooks.init

    Kaminari.configure do |config|
      config.default_per_page = 50
      config.max_per_page = 50
    end
end

RSpec.configure do |config|
  config.order = 'random'
  config.include SetupAndTeardownAdapter
  config.include ActionController::TestCase::Behavior
end
