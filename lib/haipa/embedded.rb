module Haipa
  class Embedded
    extend Forwardable

    attr_reader :data, :api
    alias :to_hash :data
    def_delegators :@data, :empty?, :has_key?

    def initialize(api, data)
      @data = data
      @api = api
    end

    def method_missing(name, *args, &block)
      name = name.to_s
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
      Resource.new(api, uri, hash)
    end
  end
end
