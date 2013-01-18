
module Responders
  module PaginateResponder
    def to_format
      if get? && resource.respond_to?(:paginate)
        @resource = resource.paginate :page => self.page, :per_page => self.per_page

        controller.response.link(controller.url_for(request.params.merge(:page => 1)), :rel => "first")
        controller.response.link(controller.url_for(request.params.merge(:page => page - 1)), :rel => "prev") if page > 1
        controller.response.link(controller.url_for(request.params.merge(:page => page + 1)), :rel => "next") if total_pages && page < total_pages
        controller.response.link(controller.url_for(request.params.merge(:page => total_pages)), :rel => "last") if total_pages
        controller.response.headers["X-Total-Pages"] = total_pages if total_pages
      end
      super
    end

    def page
      @page ||= controller.page if controller.respond_to? :page
      @page ||= controller.params[:page].try(:to_i)
      @page ||= 1
      @page
    rescue
      1
    end

    def total_pages
      @total_pages ||= resource.total_pages if resource.respond_to? :total_pages
      @total_pages
    end

    def per_page
      @per_page ||= controller.per_page if controller.respond_to? :per_page
      @per_page ||= controller.params[:per_page].try(:to_i)
      @per_page = [[1, @per_page].max, max_per_page].min
      @per_page
    rescue
      max_per_page
    end

    def max_per_page
      @max_per_page ||= controller.max_per_page if controller.respond_to? :max_per_page
      @max_per_page ||= 50
      @max_per_page
    end
  end
end
