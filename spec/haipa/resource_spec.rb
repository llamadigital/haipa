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
    specify { expect(subject.links.self).to be }
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
      expect(subject.links.find(id:1, filter1:'hello', filter2:'world').uri).
        to eq(uri+'/things/1?filter1=hello&filter2=world')
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
    specify { expect(subject.embedded).not_to be_empty }
    specify { expect(subject.resources.thing).to be_a Haipa::Resource }
    specify { expect(subject.resources.things.first).to be_a Haipa::Resource }
    specify { expect(subject.resources.thing.get.fetch('name')).to eq('thing') }
    specify { expect(subject.resources.things.first.get.fetch('name')).to eq('thing') }
  end
end
