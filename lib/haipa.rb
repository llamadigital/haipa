require 'uri'
require 'forwardable'
require 'hashie'

require 'haipa/version'
require 'haipa/api'
require 'haipa/resource'
require 'haipa/links'

module Haipa
  def self.api(params={})
    Api.new(params, &Proc.new)
  end
end
