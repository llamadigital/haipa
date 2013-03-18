require_relative 'spec_helper'

describe Haipa do
  let(:description) { {message:'hello'} }
  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  let(:client) { Faraday.new { |builder| builder.adapter :test, stubs } }

  # specify { p client.get('/') }
end
