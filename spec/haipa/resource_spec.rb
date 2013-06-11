require_relative '../spec_helper'

describe Haipa::Resource do
  let(:uri) { '/api/v1' }
  let(:response) { double('response', body:body.to_json, success?:true) }
  let(:api) { double('api', get:response) }
  subject { Haipa::Resource.new(api, uri) }

  context "with minimum response" do
    let(:body) { {'_embedded' => {}, '_links' => {'self' => {'href' => uri}}} }
    its(:embedded) { should be_empty }
    its(:resources) { should be_empty }
    its(:links) { should_not be_empty }
    specify { subject.links.self.should be }
  end

  context "with a templated find" do
    let(:body) do
      {
        '_embedded' => { },
        '_links' => {
          'self' => {'href' => uri},
          'find' => {'href' => uri+'/things/{id}{?filter1,filter2}', 'templated' => true}
        }
      }
    end
    it 'resolves the template' do
      subject.links.find(id:1, filter1:'hello', filter2:'world').uri.should be ==
        uri+'/things/1?filter1=hello&filter2=world'
    end
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
