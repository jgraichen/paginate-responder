module Responders
  module KaminariResponder
    
    def to_format
      raise "Kaminari is not installed" unless defined?(Kaminari)

      if get?
        @resource = resource.page(page).per(per_page)

        controller.response.link(controller.url_for(request.params.merge(:page => 1)), :rel => "first")
        controller.response.link(controller.url_for(request.params.merge(:page => page - 1)), :rel => "prev") if page > 1
        controller.response.link(controller.url_for(request.params.merge(:page => page + 1)), :rel => "next") if num_pages && page < num_pages
        controller.response.link(controller.url_for(request.params.merge(:page => num_pages)), :rel => "last") if num_pages
        controller.response.headers["X-Total-Pages"] = num_pages.to_s if num_pages
      end
      super
    end

    def page
      @page ||= (params[:page] || 1).to_i
    end

    def num_pages
      @num_pages ||= resource.num_pages
    end

    def per_page
      @per_page ||= (params[:per_page] || Kaminari.config.default_per_page).to_i
    end

    def params
      controller.params
    end
  end
end
