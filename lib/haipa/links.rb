module Haipa
  class Links
    extend Forwardable

    attr_reader :links, :parent
    def_delegators :@links, :empty?, :has_key?

    def initialize(parent, links)
      @links = links
      @parent = parent
    end

    def method_missing(name, *args, &block)
      if links.has_key?(name)
        Resource.new(parent.api, links[name][:href])
      else
        super
      end
    end
  end
end
