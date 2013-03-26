module Haipa
  class Embedded
    extend Forwardable

    attr_reader :resource
    def_delegators :@data, :empty?, :has_key?, :fetch

    def initialize(resource, data)
      @data = data
      @resource = resource
    end

    def method_missing(name, *args, &block)
      if @data.has_key?(name)
        from_array(@data[name])
      else
        super
      end
    end

    def to_hash
      @data
    end

    private

    def from_array(array_or_hash)
      if array_or_hash.kind_of?(Array)
        array_or_hash.map{ |e| from_hash(e) }
      else
        from_hash(array_or_hash)
      end
    end

    def from_hash(hash)
      uri = hash.fetch('_links',{}).fetch('self',{}).fetch('href',nil)
      Resource.new(resource.api, uri, hash)
    end
  end
end
