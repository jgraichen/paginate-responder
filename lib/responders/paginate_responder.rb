module Responders

  module PaginateResponder

    def to_format
      if get?
        @resource = ::PaginateResponder::Paginator.new(self).paginate!
        controller.instance_variable_set "@#{controller.controller_name}", @resource
      end
      super
    end
  end
end
