require 'minitest/autorun'
require 'bundler'

Bundler.setup

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'active_support'
require 'action_controller'
require 'will_paginate/array'

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

class PaginationResponder < ActionController::Responder
  include Responders::PaginateResponder
end

class PaginateController < ActionController::Base
  include Responders::Routes.url_helpers

  self.responder = PaginationResponder
  respond_to :json

  def index
    respond_with ('AA'..'zz').to_a
  end
end
