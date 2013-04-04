module Haipa
  class Api
    extend Forwardable

    attr_reader :conn, :resource, :uri
    def_delegators :@conn, :get
    def_delegators :@resource, :links, :embedded, :href, :resources
    alias :connection :conn

    def initialize(params={})
      @uri = URI(params[:url].to_s).path
      @conn = Faraday.new(defaults.deep_merge(params)) do |conn|
        yield conn if block_given?
      end
      @resource = Resource.new(self, @uri)
    end

    def defaults
      {
        :headers =>
        {
          :accept => 'application/hal+json',
          :user_agent => 'Haipa'
        }
      }.extend(Hashie::Extensions::DeepMerge)
    end

    def clear
      @resource.clear
      self
    end

    def description
      resource.get
    end
  end
end
