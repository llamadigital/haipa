module Haipa
  class Links
    extend Forwardable

    attr_reader :resource
    def_delegators :@data, :empty?, :has_key?

    def initialize(resource, data)
      @data = data
      @resource = resource
    end

    def to_hash
      @data
    end

    def method_missing(name, *args, &block)
      if @data.has_key?(name)
        Resource.new(resource.api, @data[name]['href'])
      else
        super
      end
    end
  end
end
