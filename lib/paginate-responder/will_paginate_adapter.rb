module PaginateResponder
  #
  # Pagination adapter for will_paginate.
  #
  class WillPaginateAdapter < Base
    def paginate
      resource.paginate page: page, per_page: per_page
    end

    def total_pages
      resource.total_pages if resource.respond_to? :total_pages
    end

    def total_count
      resource.total_entries if resource.respond_to? :total_entries
    end

    def default_per_page
      50
    end

    def default_max_per_page
      50
    end

    class << self
      def suitable?(resource, responder)
        resource.respond_to? :paginate
      end
    end
  end

  if defined?(:WillPaginate)
    ::Responders::PaginateResponder.register WillPaginateAdapter
  end
end
