require 'spec_helper'
require 'yaml'
describe 'Live Test' do
  let(:config){ YAML.load(File.read(File.dirname(__FILE__) + '/auth_secrets.yml'))}
  let(:library_card) {config['library_card']}
  let(:zip_code) {config['zip_code']}
  let(:crawler){ BookWorm::CplCrawler.new(library_card, zip_code)}

  it 'logs and gets to the account detail succesfully', :live => true do
    home_page = crawler.send(:login!)
    crawler.send(:logged_in?).should == true
    home_page.content.should include('You are logged into')
    home_page.content.should include('My Library Card', 'My Personal Information', 'My Preferred Library')
    account_detail = crawler.send(:account_detail_page)
    account_detail.content.should include('My CPL Account Detail')
  end

end
