require 'spec_helper'
require File.join(AppRoot, 'cpl_crawler')
describe CplCrawler do
# Commented out this test because is goes online and I want fast tests  
#  it "should be able to login into the CPL website" do
#    c = CplCrawler.new('d054635158', '60626')
#    c.login_to_library.content.should include('My Library Card', 'My Personal Information', 'My Preferred Library')
#  end
  

  it 'initializes with library card number and zip code' do
    parser = described_class.new('g1234', '60606')
    parser.zip_code.should == '60606'
    parser.library_card.should == 'g1234'
  end
  describe 'Authentication:' do
    it 'logs into library using card number and zip code'
    it 'sets the homepage after logging in to the library'
  end
  it 'can browse to summary page after reaching the homepage'
  it 'has the held items in the summary page'
  it 'has the checked out items in the summary page'
  it 'has the overdue items in the summary page'
  it 'has the fines in the summary page'

end
