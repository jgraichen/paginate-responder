require 'test_helper.rb'

class PaginateResponderTest < ActionController::TestCase
  tests PaginateController

  def test_pagination
    get :index, :format => :json

    puts response.headers
  end
end
