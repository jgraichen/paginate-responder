require 'test_helper.rb'
require 'pagination_tests'

require 'will_paginate/array'

class PaginateResponderTest < ActionController::TestCase
  tests PaginateController

  def setup
    @controller.resource = resource
  end

  include PaginationTests
end
