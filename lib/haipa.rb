require 'haipa/version'
require 'haipa/api'
require 'haipa/resource'

module Haipa
  def self.api(params={})
    Api.new(params, &Proc.new)
  end
end
