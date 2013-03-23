require_relative '../spec_helper'

describe Haipa::Resource do
  let(:uri) { '/api/v1' }
  let(:response) { double('response', body:body.to_json) }
  let(:api) { double('api', relative_get:response) }
  subject { Haipa::Resource.new(api, uri) }

  context "with minimum response" do
    let(:body) { {'_embedded' => {}, '_links' => {'self' => {'href' => uri}}} }
    its(:embedded) { should be_empty }
    its(:links) { should_not be_empty }
    specify { subject.links.self.should be }
  end
end
