require 'minitest/autorun'
require 'bundler'

Bundler.setup

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'active_support'
require 'action_controller'
require 'minitest/reporters'
MiniTest::Reporters.use!

require 'paginate-responder'

Responders::Routes = ActionDispatch::Routing::RouteSet.new
Responders::Routes.draw do
  match '/index' => 'paginate#index'
end

class ActiveSupport::TestCase
  setup do
    @routes = Responders::Routes
  end
end

class TestResponder < ActionController::Responder
  include Responders::PaginateResponder
end

class PaginateController < ActionController::Base
  attr_accessor :resource
  include Responders::Routes.url_helpers
  self.responder = TestResponder
  respond_to :json

  def index
    respond_with resource
  end
end
