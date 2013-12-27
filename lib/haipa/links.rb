module Haipa
  class Links
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
      if @data.has_key?(name)
        href = @data[name]['href']
        if @data[name]['templated'] == true
          template = Addressable::Template.new(href)
          options = args.last.is_a?(::Hash) ? args.pop : {}
          href = template.expand(options).to_s
        end
        Resource.new(api, href)
      else
        super
      end
    end
  end
end
