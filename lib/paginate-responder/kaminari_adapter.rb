# frozen_string_literal: true

module PaginateResponder
  #
  # Pagination adapter for kaminari.
  #
  class KaminariAdapter < Base
    def paginate
      resource.page(page).per(per_page)
    end

    def default_per_page
      Kaminari.config.default_per_page
    end

    def default_max_per_page
      Kaminari.config.max_per_page
    end

    def total_pages
      return resource.total_pages if resource.respond_to? :total_pages

      resource.num_pages   if resource.respond_to? :num_pages
    end

    def total_count
      resource.total_count if resource.respond_to? :total_count
    end

    class << self
      def suitable?(resource, _responder)
        resource.respond_to?(:page) && !resource.respond_to?(:paginate)
      end
    end
  end

  ::Responders::PaginateResponder.register(KaminariAdapter)
end
