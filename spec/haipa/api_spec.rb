require_relative '../spec_helper'

describe Haipa::Api do
  let(:description) { {'_embedded' => {}, '_links' => {'self' => {'href' => '/'}}} }

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  subject { Haipa.api { |builder| builder.adapter :test, stubs } }

  specify { expect(subject.description).to eq(description) }
  specify { expect(subject.links.to_hash).to eq(description['_links']) }
  specify { expect(subject.embedded.to_hash).to eq(description['_embedded']) }
  specify { expect(subject.href).to eq(description['_links']['self']['href']) }
end
