module Haipa
  class Resource
    attr_reader :api, :uri

    def initialize(api, uri, get=nil)
      @api = api
      @uri = uri
      @get = get
    end

    def self.from_get(api, get)
    end

    def self.from_embedded_hash(api, embedded)
      hash = Hash[embedded.map{ |name, e| [name, from_embedded_array(api, e)] }]
      ::Hashie::Mash.new(hash)
    end

    def self.from_embedded_array(api, embedded)
      if embedded.is_a?(Array)
        embedded.map{ |e| from_embedded(api, e) }
      else
        from_embedded(api, embedded)
      end
    end

    def self.from_embedded(api, embedded)
      uri = embedded.fetch('_links',{}).fetch('self',{}).fetch('href',nil)
      Resource.new(api, uri, embedded)
    end

    def clear
      @get = nil
      self
    end

    def get
      if uri
        @get ||= ::Hashie::Mash.new(JSON.parse(api.get(uri).body))
      end
    end

    def reget
      clear
      get
    end

    def embedded
      get.fetch('_embedded', {})
    end

    def resources
      Resource.from_embedded_hash(api, embedded)
    end

    def links
      Links.new(self, get.fetch('_links', {}))
    end

    def href
      (links.self || {}).fetch('href', nil)
    end
  end
end
