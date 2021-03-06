require 'spec_helper'

describe Unimedia::LinkGenerator do
  let(:page_stub)     { PageFixtures.load('unimedia_main.html') }

  before do
    RestClient.stub(:get).with(Unimedia::LinkGenerator::MAIN_URL).and_return(page_stub)
    subject.stub(:default_id).and_return(68100)
  end

  context 'when there are some links in the database' do
    let!(:latest_link)  { FactoryGirl.create(:link, news_source: :unimedia) }

    it 'stores the links in the database' do
      expect { subject.fetch }.to change { Link.all.count }.by(4)
    end
  end

  context 'when there are no links' do
    it 'generates the default permalink' do
      Link.count.should == 0
      subject.fetch
      Link.count.should be > 50
    end
  end
end
