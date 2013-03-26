require_relative '../spec_helper'

describe Haipa::Resource do
  let(:uri) { '/api/v1' }
  let(:response) { double('response', body:body.to_json) }
  let(:api) { double('api', get:response) }
  subject { Haipa::Resource.new(api, uri) }

  context "with minimum response" do
    let(:body) { {'_embedded' => {}, '_links' => {'self' => {'href' => uri}}} }
    its(:embedded) { should be_empty }
    its(:resources) { should be_empty }
    its(:links) { should_not be_empty }
    specify { subject.links.self.should be }
  end

  it 'works' do
    # template = Addressable::Template.new('/api{?q1,q2}')
    # ap template.expand({'q1' => 'hello', 'q2' => 'bye'}).to_s
  end

  context "with embedded resources" do
    let(:body) do
      {
        '_embedded' => {
          'things' => [{
            'name'=>'thing',
            '_links' => {'self' => {'href' => uri+'/things/1'}}
          }],
          'thing'=>{
            'name'=>'thing',
            '_links' => {'self' => {'href' => uri+'/things/1'}}
          }
        },
        '_links' => {'self' => {'href' => uri}}
      }
    end
    specify { subject.embedded.should_not be_empty }
    specify { subject.resources.thing.should be_a Haipa::Resource }
    specify { subject.resources.things.first.should be_a Haipa::Resource }
    specify { subject.resources.thing.get.name.should be == 'thing' }
    specify { subject.resources.things.first.get.name.should be == 'thing' }
  end
end
