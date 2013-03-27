module Haipa
  class Resource
    attr_reader :api, :uri

    def initialize(api, uri, data=nil)
      @api = api
      @uri = uri
      @data = data
    end

    def clear
      @data = nil
      self
    end

    def get
      return {} unless uri
      @data ||= ::Hashie::Mash.new(JSON.parse(api.get(uri).body))
    end

    def embedded
      Embedded.new(self, get.fetch('_embedded', {}))
    end
    alias :resources :embedded

    def links
      Links.new(self, get.fetch('_links', {}))
    end

    def href
      (links.to_hash.self || {}).fetch('href', nil)
    end
  end
end
