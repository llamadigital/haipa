module Haipa
  class Embedded
    extend Forwardable

    attr_reader :data, :resource
    alias :to_hash :data
    def_delegators :@data, :empty?, :has_key?

    def initialize(resource, data)
      @data = data
      @resource = resource
    end

    def method_missing(name, *args, &block)
      if data.has_key?(name)
        from_array(data[name])
      else
        super
      end
    end

    private

    def from_array(array)
      if array.kind_of?(Array)
        array.map{ |e| from_hash(e) }
      else
        from_hash(array)
      end
    end

    def from_hash(hash)
      uri = hash.fetch('_links',{}).fetch('self',{}).fetch('href',nil)
      Resource.new(resource.api, uri, hash)
    end
  end
end
