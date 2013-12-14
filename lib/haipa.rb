require 'uri'
require 'forwardable'
require 'faraday'
require 'addressable/template'
require 'deep_merge'

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
