module PaginateResponder
  #
  # Pagination adapter for pagy.
  #
  class PagyAdapter < Base
    def paginate
      self.pagy, self.pagy_resource = controller.send(self.class.pagy_method(resource), resource, page: page, items: per_page)
      pagy_resource
    end

    def total_pages
      pagy.pages
    end

    def total_count
      pagy.count
    end

    def default_per_page
      Pagy::VARS[:items]
    end

    def default_max_per_page
      Pagy::VARS[:max_items] || BigDecimal::INFINITY
    end

    def paginate!
      paginate.tap do
        update
      end
    end

    class << self
      def suitable?(resource, responder)
        responder.controller.respond_to?(pagy_method(resource), true)
      end

      def pagy_method(resource)
        %i[limit offset].all? { |model_method| resource.respond_to?(model_method) } ? :pagy : :pagy_array
      end
    end

    private

    attr_accessor :pagy, :pagy_resource
  end

  if defined?(:Pagy)
    ::Responders::PaginateResponder.register PagyAdapter
  end
end
