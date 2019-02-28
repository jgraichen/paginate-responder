module Responders
  module PaginateResponder
    def respond
      paginate! if get? || request.head?

      super
    end

    private

    def paginate!
      adapter = ::Responders::PaginateResponder.init(self)
      @resource = adapter.paginate! if adapter
    end

    class << self
      def register(adapter)
        adapters << adapter
      end

      def adapters
        @adpaters ||= ::Set.new
      end

      def init(responder)
        if responder.controller.respond_to?(:pagination_adapter_init)
          return responder.controller.pagination_adapter_init(responder)
        end

        adapter = find(responder)
        adapter.new(responder) if adapter
      end

      def find(responder)
        adapters.find do |adapter|
          adapter.suitable?(responder.resource, responder)
        end
      end
    end
  end
end
