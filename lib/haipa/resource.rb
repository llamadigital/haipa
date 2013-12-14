module Haipa
  class EmptyResponseError < StandardError; end
  class FailureResponseError < StandardError; end

  class Resource
    attr_reader :api, :uri, :data
    alias :to_hash :data

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
      return @data if @data
      return {} unless uri
      response = api.get(uri)
      raise FailureResponseError unless response.success?
      raise EmptyResponseError if !response.body || response.body.empty?
      @data = ::Hashie::Mash.new(JSON.parse(response.body))
    end

    def delete
      api.delete(uri)
    end

    def post(body)
      api.post do |conn|
        conn.url uri
        conn.body = body
      end
    end

    def put(body)
      api.put do |conn|
        conn.url uri
        conn.body = body
      end
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
