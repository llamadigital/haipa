require 'uri'
require 'forwardable'
require 'hashie'
require 'faraday'
require 'addressable/template'

require 'haipa/version'
require 'haipa/api'
require 'haipa/resource'
require 'haipa/links'
require 'haipa/embedded'

module Haipa
  def self.api(params={}, &block)
    Api.new(params, &block)
  end
end
