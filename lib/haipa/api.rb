module Haipa
  class Api
    extend Forwardable

    attr_reader :conn, :resource, :uri
    def_delegators :@conn, :get, :post, :put, :delete
    def_delegators :@resource, :links, :embedded, :href, :resources, :to_hash
    alias :connection :conn
    alias :description :resource

    def initialize(params={})
      @uri = URI(params[:url].to_s).path
      @conn = Faraday.new(defaults.deep_merge(params)) do |conn|
        yield conn if block_given?
      end
      @resource = Resource.new(self,'')
    end

    def defaults
      {
        :headers =>
        {
          'Accept' => 'application/hal+json',
          'UserAgent' => 'Haipa',
          'Content-Type' => 'application/hal+json'
        }
      }.extend(Hashie::Extensions::DeepMerge)
    end

    def clear
      resource.clear
      self
    end
  end
end
