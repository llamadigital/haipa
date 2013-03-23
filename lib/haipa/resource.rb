module Haipa
  class Resource
    attr_reader :api, :uri

    def initialize(api, uri)
      @api = api
      @uri = uri
      clear
    end

    def clear
      @get = nil
    end

    def get
      @get ||= ::Hashie::Mash.new(JSON.parse(api.get(uri).body))
    end

    def embedded
      get.fetch('_embedded', {})
    end

    def links
      Links.new(self, get.fetch('_links', {}))
    end

    def href
      (links.self || {}).fetch('href', nil)
    end
  end
end
