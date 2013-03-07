require 'rack-link_headers'

module Responders
  autoload :PaginateResponder, 'responders/paginate_responder'
end

module PaginateResponder
  autoload :VERSION, 'paginate-responder/version'
  autoload :Paginator, 'paginate-responder/paginator'

  module Adapter
    autoload :Base, 'paginate-responder/adapter/base'
  end
end

require 'paginate-responder/adapter/paginate_adapter'
require 'paginate-responder/adapter/kaminari_adapter'
