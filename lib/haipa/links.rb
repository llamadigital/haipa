module Haipa
  class Links
    extend Forwardable

    attr_reader :data, :resource
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
        href = @data[name]['href']
        if @data[name]['template'] == true
          template = Addressable::Template.new(href)
          options = args.last.is_a?(::Hash) ? args.pop : {}
          href = template.expand(options).to_s
        end
        Resource.new(resource.api, href)
      else
        super
      end
    end
  end
end
