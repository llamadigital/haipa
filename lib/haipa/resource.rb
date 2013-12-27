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

    def duplicate
      Resource.new(api, uri)
    end

    def get
      return @data if @data
      return {} unless uri
      response = api.get(uri)
      assert_body!(response)
      raise FailureResponseError unless response.success?
      @data = parse(response)
    end

    def delete
      api.delete(uri)
    end

    ##
    # This POSTs to this resource and returns a new resource the new resource
    # is populated from the location header uri and the optional response body
    # This is an example of POSTing to an existing resource to create a new
    # subordinate one, eg POSTing to /users to create a /users/:id resource
    # An alternative scheme is to POST to a non existing resource to create
    # itself. eg POST to /users/:email to create a user with that email. If the
    # identifier (id) is being generated by the api and not the client (for
    # example an autoincrementing database column) it would be unnatural to use
    # this latter scheme. This latter scheme is not supported at the moment.
    def post(body)
      return nil unless uri
      response = api.post do |conn|
        conn.url uri
        conn.body = generate(body)
      end
      raise FailureResponseError, "Status #{response.status}" unless response.success?
      return nil unless response.headers[:location]
      Resource.new(api, response.headers[:location], parse(response))
    end

    ##
    # This PUTs to this resource to update itself. The resource data is updated
    # with the response.
    def put(body)
      return self unless uri
      response = api.put do |conn|
        conn.url uri
        conn.body = generate(body)
      end
      raise FailureResponseError, "Status #{response.status}" unless response.success?
      @data = parse(response)
      self
    end

    def embedded
      Embedded.new(api, get.fetch('_embedded', {}))
    end
    alias :resources :embedded

    def links
      Links.new(api, get.fetch('_links', {}))
    end

    def href
      links.to_hash.fetch('self', {}).fetch('href', nil)
    end

    private

    def parse(response)
      return if response.body.to_s.strip.empty?
      JSON.parse(response.body.to_s)
    end

    def generate(body)
      case body
      when Hash, Array
        JSON.generate(body)
      else
        body
      end
    end

    def assert_body!(response)
      return unless response.success?
      return if response.status == 204
      raise EmptyResponseError if !response.body || response.body.to_s.empty?
    end
  end
end
