module Haipa
  class Resource
    attr_reader :api, :uri

    def initialize(api, uri, data=nil)
      @api = api
      @uri = uri
      @data = ::Hashie::Mash.new(data) if data
    end

    def to_hash
      get
    end

    def clear
      @data = nil
      self
    end

    def get
      return {} unless uri
      @data ||= ::Hashie::Mash.new(JSON.parse(api.get(uri).body))
    end

    def post(params={})
      api.post(uri, params) do |req|
        yield req if block_given?
      end
    end

    def put(params={})
      api.put(uri, params) do |req|
        yield req if block_given?
      end
    end

    def delete(params={})
      api.delete(uri, params) do |req|
        yield req if block_given?
      end
    end

    def embedded
      @embedded ||= Embedded.new(self, get.fetch('_embedded', {}))
    end
    alias :resources :embedded

    def links
      @links ||= Links.new(self, get.fetch('_links', {}))
    end

    def href
      (links.to_hash.self || {}).fetch('href', nil)
    end
  end
end
