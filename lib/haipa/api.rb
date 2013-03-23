module Haipa
  class Api
    extend Forwardable

    attr_reader :conn, :resource, :uri
    def_delegators :@conn, :get
    def_delegators :@resource, :links, :embedded, :href
    alias :connection :conn

    def initialize(params={})
      @uri = URI(params[:url].to_s).path
      @conn = Faraday.new(defaults.merge(params)) do |conn|
        yield conn if block_given?
      end
      @resource = Resource.new(self,'')
    end

    def defaults
      {
        :headers =>
        {
          :accept => 'application/hal+json',
          :user_agent => 'Haipa'
        }
      }
    end

    def clear
      @resource = nil
    end

    def description
      resource.get
    end
  end
end
