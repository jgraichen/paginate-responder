# frozen_string_literal: true

class ArModel < ActiveRecord::Base
  has_many :ar_assoc_models

  def as_json(_opts = {})
    id
  end
end

class ArAssocModel < ActiveRecord::Base
  def as_json(_opts = {})
    id
  end
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
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

ROUTES = ActionDispatch::Routing::RouteSet.new
ROUTES.draw do
  get '/index' => 'test#index'
end

class TestController < ActionController::Base
  include ROUTES.url_helpers

  self.responder = TestResponder

  respond_to :json

  def initialize(&block)
    super
    @cb = block
  end

  def index
    respond_with @cb.call
  end
end

RSpec.configure do |config|
  config.before do
    @routes = ROUTES
    @controller = TestController.new { resource }
  end
end
