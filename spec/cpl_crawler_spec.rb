require 'spec_helper'
require File.join(AppRoot, 'cpl_crawler')
describe CplCrawler do
# Commented out this test because is goes online and I want fast tests  
#  it "should be able to login into the CPL website" do
#    c = CplCrawler.new('d054635158', '60626')
#    c.login_to_library.content.should include('My Library Card', 'My Personal Information', 'My Preferred Library')
#  end
  
  let(:parser){ parser = described_class.new('g1234', '60606')}

  it 'initializes with library card number and zip code' do
    parser = described_class.new('g1234', '60606')
    parser.zip_code.should == '60606'
    parser.library_card.should == 'g1234'
  end

  it 'has an http_agent used to browse pages' do
    parser.http_agent.should respond_to(:get)
  end
  
  describe 'Authentication:' do
    let(:login_page){double 'Login Page', :form_with => login_form} 
    let(:login_form){double 'Login Form', :click_button => :page_after_login,
                                          :patronId= => parser.library_card,
                                          :zipCode= => parser.zip_code}
    before :each do
      http_agent = double 'HTTP Agent', :get => login_page
      parser.stub(:http_agent).and_return(http_agent)
    end
    it '1. retrieves the login page' do
      parser.send(:login_page).should == login_page
    end
    it '2. finds the login form on the login page' do
      parser.send(:login_form).should == login_form
    end
    it '3. fills in the form' do
      login_form.should_receive(:patronId=).with(parser.library_card)
      login_form.should_receive(:zipCode=).with(parser.zip_code)
      parser.send(:filled_in_login_form).should == login_form
    end
    it '4. submits the form and gets the homepage for successful login' do
      parser.send(:login!).should == :page_after_login
    end

    it 'sets the homepage after logging in to the library' do
      parser.send(:home_page).should == :page_after_login
    end
  end
  it 'can browse to summary page after reaching the homepage'
  it 'has the held items in the summary page'
  it 'has the checked out items in the summary page'
  it 'has the overdue items in the summary page'
  it 'has the fines in the summary page'

end
