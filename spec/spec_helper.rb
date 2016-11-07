require 'rubygems'
require 'bundler/setup'

# Configure Rails
ENV['RAILS_ENV'] = 'test'

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

RSpec.configure do |config|
  config.order = 'random'
  config.include SetupAndTeardownAdapter
  config.include ActionController::TestCase::Behavior
end
