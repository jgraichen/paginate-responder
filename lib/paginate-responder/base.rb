module PaginateResponder
  class Base
    attr_reader :responder, :resource

    def initialize(responder)
      @responder = responder
      @resource  = responder.resource
    end

    def request
      responder.request
    end

    def controller
      responder.controller
    end

    def response
      controller.response
    end

    def paginate!
      @resource = paginate

      update

      @resource
    end

    protected

    def paginate
      resource
    end

    def update
      link! 'first', page: first_page if first_page
      link! 'prev',  page: prev_page  if prev_page
      link! 'next',  page: next_page  if next_page
      link! 'last',  page: last_page  if last_page

      response.headers["X-Total-Pages"] = total_pages.to_s if total_pages
      response.headers["X-Total-Count"] = total_count.to_s if total_count
      response.headers["X-Per-Page"]    = per_page.to_s    if per_page
    end

    def page
      @page ||= begin
        val ||= controller.page if controller.respond_to? :page
        val ||= controller.params[:page]
        val ||= first_page
        cast_page val
      end
    end

    def cast_page(page)
      Integer(page)
    end

    def per_page
      @per_page ||= begin
        val ||= controller.per_page if controller.respond_to? :per_page
        val ||= controller.params[:per_page].try(:to_i)
        val ||= default_per_page
        val < 1 ? 1 : (val > max_per_page) ? max_per_page : val
      end
    end

    def max_per_page
      @max_per_page ||= begin
        val ||= controller.max_per_page if controller.respond_to? :max_per_page
        val ||= default_max_per_page
        val
      end
    end

    def first_page
      1
    end

    def prev_page
      page - 1 if page > 1
    end

    def next_page
      page + 1 if total_pages && page < total_pages
    end

    def last_page
      total_pages
    end

    def total_pages
      nil
    end

    def total_count
      nil
    end

    def default_per_page
      50
    end

    def default_max_per_page
      100
    end

    private

    def link!(rel, params)
      if request.params.key?(:per_page)
        params = {per_page: per_page}.merge(params)
      end

      params = request.params.merge(params)

      url = controller.url_for(params)

      response.link(url, rel: rel)
    end

    class << self
      def suitable?(resource)
        false
      end
    end
  end
end
