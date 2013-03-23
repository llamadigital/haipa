require_relative 'spec_helper'

describe Haipa do
  let(:description) { {'_links' => {'self' => {'href' => '/'}}} }

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  subject { Haipa.api { |builder| builder.adapter :test, stubs } }

  its(:description) { should eq(description) }
end
