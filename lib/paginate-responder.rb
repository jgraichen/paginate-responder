require 'rack-link_headers'

module Responders
  require 'responders/paginate_responder'
end

module PaginateResponder
  require 'paginate-responder/version'
  require 'paginate-responder/base'
  require 'paginate-responder/will_paginate_adapter'
  require 'paginate-responder/kaminari_adapter'
  require 'paginate-responder/pagy_adapter'
end
