module PaginateResponder::Adapter

  # Pagination adapter for will_paginate.
  #
  class PaginateAdapter < Base

    def suitable?
      defined?(:WillPaginate) and resource.respond_to?(:paginate)
    end

    def paginate(opts)
      resource.paginate :page => opts[:page], :per_page => opts[:per_page]
    end

    def defaults
      { :per_page => 50, :max_per_page => 50 }
    end

    def total_pages
      resource.total_pages if resource.respond_to? :total_pages
    end
  end
end
