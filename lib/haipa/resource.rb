module Haipa
  class Resource
    attr_reader :api, :uri

    def initialize(api, uri, get=nil)
      @api = api
      @uri = uri
      @get = get
    end

    def clear
      @get = nil
      self
    end

    def get
      return {} unless uri
      @get ||= ::Hashie::Mash.new(JSON.parse(api.get(uri).body))
    end

    def embedded
      Embedded.new(self, get.fetch('_embedded', {}))
    end
    alias :resources :embedded

    def links
      Links.new(self, get.fetch('_links', {}))
    end

    def href
      (links.self || {}).fetch('href', nil)
    end
  end
end
