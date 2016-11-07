module Responders
  module PaginateResponder
    def to_format
      paginate! if get?

      super
    end

    private

    def paginate!
      adapter = ::Responders::PaginateResponder.find(self)
      @resource = adapter.new(self).paginate! if adapter
    end

    class << self
      def register(adapter)
        adapters << adapter
      end

      def adapters
        @adpaters ||= ::Set.new
      end

      def find(responder)
        adapters.find do |adapter|
          adapter.suitable?(responder.resource, responder)
        end
      end
    end
  end
end
