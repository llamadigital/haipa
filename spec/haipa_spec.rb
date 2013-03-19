require_relative 'spec_helper'

describe Haipa do
  let(:description) { {'_links' => {'self' => {'href' => 'http://example.com/'}}} }

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  subject { Haipa.api { |builder| builder.adapter :test, stubs } }

  its(:description) { should eq(description) }
  its(:links) { should eq(description['_links']) }
  its(:link_self) { should eq(description['_links']['self']) }
  its(:link_self_href) { should eq(description['_links']['self']['href']) }
end
