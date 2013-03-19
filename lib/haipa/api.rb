require 'forwardable'

module Haipa
  class Api
    extend Forwardable

    attr_reader :conn, :resource
    def_delegators :@conn, :get

    def initialize(params={})
      @conn = Faraday.new(params) do |builder|
        yield builder if block_given?
      end
      @resource = Resource.new(self,'/')
    end

    def clear
      @resource = nil
    end

    def description
      resource.get
    end

    def links
      resource.links
    end

    def link_self
      resource.link_self
    end

    def link_self_href
      resource.link_self_href
    end
  end
end
