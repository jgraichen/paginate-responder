module PaginateResponder::Adapter

  # Pagination adapter for will_paginate.
  #
  class PaginateAdapter < Base

    def suitable?
      resource.respond_to?(:paginate)
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

    def total_count
      resource.total_entries if resource.respond_to? :total_entries
    end
  end

  if defined?(:WillPaginate)
    ::PaginateResponder::Paginator.register PaginateAdapter
  end
end
