require_relative '../spec_helper'

describe Haipa::Api do
  let(:description) { {'_embedded' => {}, '_links' => {'self' => {'href' => '/'}}} }

  let(:stubs) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/') { [200, {}, description.to_json] }
    end
  end
  subject { Haipa.api { |conn| conn.adapter :test, stubs } }

  specify { subject.description.to_hash.should == description }
  specify { subject.links.to_hash.should == description['_links'] }
  specify { subject.embedded.to_hash.should == description['_embedded'] }
  specify { subject.href.should == description['_links']['self']['href'] }
end
