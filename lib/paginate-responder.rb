require 'rack-link_headers'

module Responders
  autoload :PaginateResponder, 'responders/paginate_responder'
end

module PaginateResponder
  autoload :VERSION, 'paginate-responder/version'
end
