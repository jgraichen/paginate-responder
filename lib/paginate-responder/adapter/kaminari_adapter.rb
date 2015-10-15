module PaginateResponder::Adapter

  # Pagination adapter for kaminari.
  #
  class KaminariAdapter < Base

    def suitable?
      resource.respond_to?(:page) and not resource.respond_to?(:paginate)
    end

    def paginate(opts)
      resource.page(opts[:page]).per(opts[:per_page])
    end

    def defaults
      {
          :per_page => Kaminari.config.default_per_page,
          :max_per_page => Kaminari.config.max_per_page
      }
    end

    def total_pages
      resource.num_pages if resource.respond_to? :num_pages
    end

    def total_count
      resource.total_count if resource.respond_to? :total_count
    end
  end

  if defined?(:Kaminari)
    ::PaginateResponder::Paginator.register KaminariAdapter
  end
end
