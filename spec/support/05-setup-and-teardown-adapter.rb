module SetupAndTeardownAdapter
  extend ActiveSupport::Concern

  module ClassMethods
    # Wraps `setup` calls from within Rails' testing framework in `before`
    # hooks.
    def setup(*methods, &block)
      methods.each do |method|
        if method.to_s =~ /^setup_(with_controller|fixtures|controller_request_and_response)$/
          prepend_before { __send__ method }
        else
          before         { __send__ method }
        end
      end
      before(&block) if block
    end

    # @api private
    #
    # Wraps `teardown` calls from within Rails' testing framework in
    # `after` hooks.
    def teardown(*methods, &block)
      methods.each { |method| after { __send__ method } }
      after(&block) if block
    end
  end

  def initialize(*args)
    super
    @example = nil
  end

  def method_name
    @example
  end

  attr_accessor :request, :params
end
