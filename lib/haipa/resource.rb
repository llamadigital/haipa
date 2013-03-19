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
      @get ||= JSON.load(api.conn.get(uri).body)
    end

    def links
      get.fetch('_links',{})
    end

    def link_self
      links.fetch('self', nil)
    end

    def link_self_href
      (link_self || {}).fetch('href', nil)
    end
  end
end
