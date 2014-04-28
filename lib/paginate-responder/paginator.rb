module PaginateResponder
  class Paginator
    attr_reader :responder, :adapter, :resource

    def initialize(responder)
      @responder = responder
      @resource  = responder.resource
      @adapter   = find_adapter
    end

    def find_adapter
      return controller.pagination_adapter(resource) if controller.respond_to? :pagination_adapter

      Adapter::Base.subclasses.each do |adapter_class|
        begin
          adapter_class.new(resource).tap do |adapter|
            return adapter if adapter.suitable?
          end
        rescue
          next
        end
      end
      Adapter::Base.new(resource)
    end

    def request; responder.request end
    def response; controller.response end
    def controller; responder.controller end

    def paginate!
      resource!
      headers!

      resource
    end

    def headers!
      link! 'first', 1
      link! 'prev', page - 1    if page > 1
      link! 'next', page + 1    if total_pages && page < total_pages
      link! 'last', total_pages if total_pages

      response.headers["X-Total-Pages"] = total_pages.to_s if total_pages
      response.headers["X-Total-Count"] = total_count.to_s if total_count
    end

    def link!(rel, page)
      response.link(controller.url_for(request.params.merge(:page => page)), :rel => rel)
    end

    def resource!
      @resource = @adapter.paginate! :page => page, :per_page => per_page
    end

    def page
      @page ||= controller.page.try(:to_i) if controller.respond_to? :page
      @page ||= controller.params[:page].try(:to_i)
      @page ||= 1
    rescue
      1
    end

    def per_page
      @per_page ||= controller.per_page.try(:to_i) if controller.respond_to? :per_page
      @per_page ||= controller.params[:per_page].try(:to_i)
      @per_page ||= @adapter.defaults[:per_page].try(:to_i)
      @per_page = [[1, @per_page].max, max_per_page].min
    rescue
      max_per_page
    end

    def max_per_page
      @max_per_page ||= controller.max_per_page.try(:to_i) if controller.respond_to? :max_per_page
      @max_per_page ||= @adapter.defaults[:max_per_page].try(:to_i)
      @max_per_page ||= 50
    end

    def total_pages
      @adapter.total_pages
    end

    def total_count
      @adapter.total_count
    end
  end
end
