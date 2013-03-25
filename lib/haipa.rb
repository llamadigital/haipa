require 'uri'
require 'forwardable'
require 'hashie'
require 'faraday'

require 'haipa/version'
require 'haipa/api'
require 'haipa/resource'
require 'haipa/links'
require 'haipa/embedded'

module Haipa
  def self.api(params={})
    Api.new(params, &Proc.new)
  end
end
