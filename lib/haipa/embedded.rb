module Haipa
  class Embedded
    extend Forwardable

    attr_reader :embedded, :resource
    def_delegators :@embedded, :empty?, :has_key?

    def initialize(resource, embedded)
      @embedded = embedded
      @resource = resource
    end

    def method_missing(name, *args, &block)
      if embedded.has_key?(name)
        from_array(embedded[name])
      else
        super
      end
    end

    private

    def from_array(data)
      if data.kind_of?(Array)
        data.map{ |e| from_hash(e) }
      else
        from_hash(data)
      end
    end

    def from_hash(hash)
      uri = hash.fetch('_links',{}).fetch('self',{}).fetch('href',nil)
      Resource.new(resource.api, uri, hash)
    end
  end
end
