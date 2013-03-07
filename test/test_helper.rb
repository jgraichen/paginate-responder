require 'minitest/autorun'
require 'bundler'

Bundler.setup

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'active_support'
require 'action_controller'
require 'active_record'
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

class ArModel < ActiveRecord::Base
  has_many :ar_assoc_models
  def as_json(opts = {}); self.id end
end

class ArAssocModel < ActiveRecord::Base
  def as_json(opts = {}); self.id end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database  => ':memory:'
)
ActiveRecord::Base.connection.execute(
    'CREATE TABLE ar_models (id INTEGER PRIMARY KEY AUTOINCREMENT);')
ActiveRecord::Base.connection.execute(
    'CREATE TABLE ar_assoc_models (id INTEGER PRIMARY KEY AUTOINCREMENT, ar_model_id INTEGER);')
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

class PaginateController < ActionController::Base
  attr_accessor :resource
  include Responders::Routes.url_helpers
  self.responder = TestResponder
  respond_to :json

  def index
    respond_with resource
  end
end
