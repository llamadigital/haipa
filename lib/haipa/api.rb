module Haipa
  class Api
    extend Forwardable

    attr_reader :conn, :resource, :uri
    def_delegators :@conn, :get, :post, :put, :delete
    def_delegators :@resource, :links, :embedded, :href, :resources
    alias :connection :conn

    def initialize(params={})
      @uri = URI(params[:url].to_s).path
      @conn = Faraday.new(defaults.deep_merge(params)) do |conn|
        if block_given?
          yield conn
        else
          conn.adapter Faraday.default_adapter
        end
      end
      @resource = Resource.new(self, @uri)
    end

    def defaults
      {
        headers:
        {
          accept: 'application/hal+json',
          user_agent: 'Haipa',
          content_type: 'application/json',
        }
      }
    end

    def duplicate
      @resource = @resource.duplicate
    end

    def description
      resource.get
    end
  end
end
