require 'test_helper.rb'
require 'pagination_tests'

require 'kaminari/config'
require 'kaminari/helpers/paginator'
require 'kaminari/models/page_scope_methods'
require 'kaminari/models/configuration_methods'
require 'kaminari/models/array_extension'

Kaminari.configure do |config|
  config.default_per_page = 50
  config.max_per_page = 50
end

class KaminariResponderTest < ActionController::TestCase
  tests PaginateController

  def setup
    @controller.resource = Kaminari.paginate_array(resource)
  end

  include PaginationTests
end
