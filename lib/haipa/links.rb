module Haipa
  class Links
    extend Forwardable

    attr_reader :links, :resource
    def_delegators :@links, :empty?, :has_key?

    def initialize(resource, links)
      @links = links
      @resource = resource
    end

    def method_missing(name, *args, &block)
      if links.has_key?(name)
        Resource.new(resource.api, links[name]['href'])
      else
        super
      end
    end
  end
end
