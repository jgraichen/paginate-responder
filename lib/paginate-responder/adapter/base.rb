module PaginateResponder::Adapter
  class Base
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def paginate!(opts)
      @resource = paginate(opts)
    end

    # If pagination for current resource is supported.
    #
    def suitable?
      false
    end

    # Return paginated resource.
    # Option hash will contain at least <tt>:per_page</tt>
    # and <tt>:page</tt>.
    #
    def paginate(opts)
      resource
    end

    # Return number of total pages for current resource.
    #
    def total_pages
      nil
    end

    # Return default values for items per page and maximum
    # items per page.
    #
    def defaults
      { :per_page => 50, :max_per_page => 100 }
    end
  end
end
