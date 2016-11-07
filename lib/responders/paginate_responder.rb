module Responders
  module PaginateResponder
    def to_format
      @resource = paginate! if get?

      super
    end

    private

    def paginate!
      ::Responders::PaginateResponder.find(self).new(self).paginate!
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
