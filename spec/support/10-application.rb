
$routes = ActionDispatch::Routing::RouteSet.new
$routes.draw do
  get '/index' => 'test#index'
end

class ActiveSupport::TestCase
  setup do
    @routes = $routes
  end
end

class ArModel < ActiveRecord::Base
  has_many :ar_assoc_models
  def as_json(opts = {})
    id
  end
end

class ArAssocModel < ActiveRecord::Base
  def as_json(opts = {})
    id
  end
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)
ActiveRecord::Base.connection.execute <<SQL
  CREATE TABLE ar_models (id INTEGER PRIMARY KEY AUTOINCREMENT);
SQL
ActiveRecord::Base.connection.execute <<SQL
  CREATE TABLE ar_assoc_models (
    id INTEGER PRIMARY KEY AUTOINCREMENT, ar_model_id INTEGER
  );
SQL

676.times do
  ArModel.create!.tap do |ar_model|
    5.times do
      ar_model.ar_assoc_models.create!
    end
  end
end

class TestResponder < ActionController::Responder
  include Responders::PaginateResponder
end

class TestController < ActionController::Base
  include $routes.url_helpers

  attr_accessor :resource

  self.responder = TestResponder

  respond_to :json

  def index
    respond_with resource
  end
end

module TestSpecConfiguration
  extend ActiveSupport::Concern

  included do
    before do
      @routes = $routes
      @controller = TestController.new
    end

    def resource=(resource)
      @controller.resource = resource
    end
  end
end

RSpec.configure do |config|
  config.include TestSpecConfiguration
end
