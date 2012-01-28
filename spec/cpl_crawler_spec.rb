require 'spec_helper'
require 'book_worm/cpl_crawler'
describe BookWorm::CplCrawler do
# Commented out this test because is goes online and I want fast tests  
#  it "should be able to login into the CPL website" do
#    c = CplCrawler.new('d054635158', '60626')
#    c.login_to_library.content.should include('My Library Card', 'My Personal Information', 'My Preferred Library')
#  end
  
  let(:crawler){ crawler = described_class.new('g1234', '60606')}
  let(:http_agent){double 'HTTP Agent'}
  before :each do
    crawler.stub(:http_agent).and_return(http_agent)
  end

  it 'initializes with library card number and zip code' do
    crawler = described_class.new('g1234', '60606')
    crawler.zip_code.should == '60606'
    crawler.library_card.should == 'g1234'
  end

  it 'has a default cpl url' do
    crawler.start_url.should match(/www\.chipublib\.org/)
  end

  it 'can change the default cpl url' do
    crawler.start_url = 'http://localhost:4567/mycpl/login' 
    crawler.start_url.should match(/localhost/)
  end

  describe 'Authentication:' do

    let(:login_page){double 'Login Page', :form_with => login_form} 
    let(:login_form){double 'Login Form', :click_button => home_page}
    let(:home_page) {double 'Home Page (Page after succesful login)'}
    let(:link_to_account_detail_page) {double 'Link to account_detail page', :click => account_detail_page}
    let(:account_detail_page){double 'account_detail Page'}

    before :each do
      http_agent.stub(:get).and_return(login_page)
      login_form.stub(:patronId=).with(crawler.library_card)
      login_form.stub(:zipCode=).with(crawler.zip_code)
      home_page.stub(:link_with).with(:text => /Checked Out/).and_return(link_to_account_detail_page)
    end


    # maybe TODO: stub all actions required for login, test login
    #  then stub actions to respond in different ways and test different failures 
    #  OR break the class into separate parts with a clear interface so it gets
    #  easier to understand, test and debug

    it '1. retrieves the login page' do
      crawler.send(:login_page).should == login_page
    end
    it '2. finds the login form on the login page' do
      crawler.send(:login_form).should == login_form
    end

    it 'handles login form missing on login page'
    it '3. fills in the form' do
      login_form.should_receive(:patronId=).with(crawler.library_card)
      login_form.should_receive(:zipCode=).with(crawler.zip_code)
      crawler.send(:filled_in_login_form).should == login_form
    end
    it '4 submits the form and gets the page after login' do
      crawler.send(:login!).should == home_page
    end
    it 'sets the homepage after logging in to the library' do
      crawler.send(:home_page).should == home_page
    end
    it 'detects if logged in by checking the account_detail page link' do
      crawler.send(:logged_in?).should == true
    end

    it 'browses to account_detail page after reaching the homepage' do
      crawler.send(:account_detail_page).should == account_detail_page
    end
    it 'has the held items in the account_detail page' do
      crawler.send(:holds_page).should == account_detail_page
    end
    it 'has the checked out items in the account_detail page' do
      crawler.send(:checked_out_page).should == account_detail_page
    end
    it 'has the overdue items in the account_detail page' do
      crawler.send(:overdue_page).should == account_detail_page
    end
    it 'has the fines in the account_detail page' do
      crawler.send(:fines_page).should == account_detail_page
    end

    describe 'misshaps:' do

      describe 'with link to account_detail page not found in home page' do
        before :each do 
          home_page.stub(:link_with).with(:text => /Checked Out/).and_return(nil)
        end

        it 'is not logged in' do
          crawler.send(:logged_in?).should == false
        end
        it 'returns nil for account_detail page' do
          crawler.send(:account_detail_page).should == nil
        end
      end

      describe 'with login page not found' do
        before :each do
          http_agent.stub(:get) do
            raise Mechanize::ResponseCodeError, '404 => Net::HTTPNotFound'
          end
        end

        it 'returns nil for account_detail page' do
          pending
          crawler.send(:account_detail_page).should == nil
        end
      end


    end

    # TODO: Move this in the happy path and get rid of stubs
    describe 'after login:' do
      let(:account_detail_page){double 'account_detail Page'} #this page contains all the info that we need 
      before :each do
        crawler.stub(:link_to_account_detail_page).and_return(:account_detail_page_link)
        crawler.http_agent.should_receive(:click).with(:account_detail_page_link).and_return(account_detail_page)
      end
    end
  end

end
