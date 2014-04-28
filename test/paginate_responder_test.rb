require 'test_helper.rb'

GEM = ENV['GEM'].to_s.split ','
GEM = [ 'will_paginate' ] if GEM.empty?
puts "[INFO] Running tests with #{GEM.join(' and ')}."

class PaginateResponderTest < ActionController::TestCase
  tests PaginateController

  def array_resource
    ('AA'..'zz').to_a
  end

  GEM.each do |gem|
    case gem
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

        def array_resource
          Kaminari.paginate_array ('AA'..'zz').to_a
        end
      else
    end
  end

  def setup
    @controller.resource = ArModel.scoped
  end
  def json; JSON[@response.body] end

  def test_pagination
    get :index, :format => :json

    assert_equal 50, json.size
    assert_equal (1..50).to_a, json
  end

  def test_pagination_arr
    @controller.resource = array_resource
    get :index, :format => :json

    assert_equal 50, json.size
    assert_equal ('AA'..'zz').to_a[0..49], json
  end

  def test_pagination_assoc
    @controller.resource = ArModel.find(1).ar_assoc_models
    get :index, :format => :json

    assert_equal 5, json.size
    assert_equal (1..5).to_a, json
  end

  def test_pagination_page_2
    get :index, :format => :json, :page => 2

    assert_equal 50, json.size
    assert_equal (51..100).to_a, json
  end

  def test_pagination_arr_page_2
    @controller.resource = array_resource
    get :index, :format => :json, :page => 2

    assert_equal 50, json.size
    assert_equal ('AA'..'zz').to_a[50..99], json
  end

  def test_pagination_per_page
    get :index, :format => :json, :page => 1, :per_page => 10

    assert_equal 10, json.size
    assert_equal (1..10).to_a, json
  end


  def test_pagination_arr_per_page
    @controller.resource = array_resource
    get :index, :format => :json, :page => 1, :per_page => 10

    assert_equal 10, json.size
    assert_equal ('AA'..'zz').to_a[0..9], json
  end

  def test_pagination_per_page_2
    get :index, :format => :json, :page => 2, :per_page => 10

    assert_equal 10, json.size
    assert_equal (11..20).to_a, json
  end

  def test_pagination_arr_per_page_2
    @controller.resource = array_resource
    get :index, :format => :json, :page => 2, :per_page => 10

    assert_equal 10, json.size
    assert_equal ('AA'..'zz').to_a[10..19], json
  end

  def test_headers
    get :index, :format => :json

    assert_equal 3, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "next", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=2", response.links[1][:url]

    assert_equal "last", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=14", response.links[2][:url]
  end

  def test_headers_page_2
    get :index, :format => :json, :page => 2

    assert_equal 4, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "prev", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[1][:url]

    assert_equal "next", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=3", response.links[2][:url]

    assert_equal "last", response.links[3][:params][:rel]
    assert_equal "http://test.host/index.json?page=14", response.links[3][:url]
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
    assert_equal "http://test.host/index.json?page=14", response.links[3][:url]
  end

  def test_headers_last_page
    get :index, :format => :json, :page => 14

    assert_equal 3, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "prev", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=13", response.links[1][:url]

    assert_equal "last", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=14", response.links[2][:url]
  end

  def test_headers_page_before_last_page
    get :index, :format => :json, :page => 13

    assert_equal 4, response.links.size

    assert_equal "first", response.links[0][:params][:rel]
    assert_equal "http://test.host/index.json?page=1", response.links[0][:url]

    assert_equal "prev", response.links[1][:params][:rel]
    assert_equal "http://test.host/index.json?page=12", response.links[1][:url]

    assert_equal "next", response.links[2][:params][:rel]
    assert_equal "http://test.host/index.json?page=14", response.links[2][:url]

    assert_equal "last", response.links[3][:params][:rel]
    assert_equal "http://test.host/index.json?page=14", response.links[3][:url]
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

    assert_equal "14", response.headers["X-Total-Pages"]
  end

  def test_headers_total_count
    get :index, :format => :json

    assert_equal "676", response.headers["X-Total-Count"]
  end
end
