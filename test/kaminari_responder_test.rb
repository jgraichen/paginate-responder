require 'test_helper.rb'

class KaminariResponder < ActionController::Responder
  include Responders::KaminariResponder
end

class KaminariController < ActionController::Base
  include Responders::Routes.url_helpers

  self.responder = KaminariResponder
  respond_to :json

  def index
    respond_with Kaminari.paginate_array(('AA'..'zz').to_a)
  end
end

class KaminiariPaginateResponderTest < ActionController::TestCase
  tests KaminariController

  def json
    JSON[@response.body]
  end

  def values
    @values ||= ('AA'..'zz').to_a
  end

  def test_pagination
    get :index, :format => :json
    assert_equal values[0..24], json
  end

  def test_pagination_page_2
    get :index, :format => :json, :page => 2
    assert_equal values[25..49], json
  end

  def test_pagination_per_page
    get :index, :format => :json, :page => 1, :per_page => 10
    assert_equal values[0..9], json
  end

  def test_pagination_per_page_page_2
    get :index, :format => :json, :page => 2, :per_page => 10
    assert_equal values[10..19], json
  end

  def test_headers
    get :index, :format => :json

    assert_equal 3, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "next", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=2", response.links[1][:url]

    assert_equal "last", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=28", response.links[2][:url]
  end

  def test_headers_page_5
    get :index, :format => :json, :page => 5

    assert_equal 4, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "prev", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=4", response.links[1][:url]

    assert_equal "next", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=6", response.links[2][:url]

    assert_equal "last", response.links[3][:params][:rel]
    assert_equal "http://test.host/index.json?page=28", response.links[3][:url]
  end

  def test_headers_last_page
    get :index, :format => :json, :page => 28

    assert_equal 3, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "prev", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=27", response.links[1][:url]

    assert_equal "last", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=28", response.links[2][:url]
  end

  def test_headers_per_page
    get :index, :format => :json, :page => 1, :per_page => 10

    assert_equal 3, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1&per_page=10", response.links[0][:url]

    assert_equal "next", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=2&per_page=10", response.links[1][:url]

    assert_equal "last", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=68&per_page=10", response.links[2][:url]
  end

  def test_headers_total_pages
    get :index, :format => :json
    assert_equal "28", response.headers["X-Total-Pages"]
  end
end
