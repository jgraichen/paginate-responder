module Responders

  module PaginateResponder

    def to_format
      if get?
        @resource = ::PaginateResponder::Paginator.new(self).paginate!
      end
      super
    end
  end
end
