require_relative '../spec_helper'

describe Haipa::Api do
  let(:description) { {'_embedded' => {}, '_links' => {'self' => {'href' => '/'}}} }

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  subject { Haipa.api { |builder| builder.adapter :test, stubs } }

  its(:description) { should eq(description) }
  its(:links) { should eq(description['_links']) }
  its(:embedded) { should eq(description['_embedded']) }
  its(:href) { should eq(description['_links']['self']['href']) }
end
