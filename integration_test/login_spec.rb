require 'spec_helper'
require_relative 'integration_env'

describe 'Crawler and Parser together' do
  it 'gets the overdue items for valid username' do
    @library_card = BookWorm::CplTest::LIBRARY_CARD_OK
    @zip_code = BookWorm::CplTest::ZIP_CODE_OK
    @crawler = BookWorm::CplCrawler.new(@library_card, @zip_code)
    @crawler.start_url = TEST_SERVER + "mycpl/login/"
    @crawler.overdue_page.should_not be_nil
  end
  it 'fails login the for invalid username' do
    @crawler = BookWorm::CplCrawler.new('bogus', '345253')
    @crawler.start_url = TEST_SERVER + "mycpl/login/"
    @crawler.overdue_page.should be_nil
  end

  it 'handles 404 login page' do
    @crawler = BookWorm::CplCrawler.new('bogus', '345253')
    @crawler.start_url = TEST_SERVER + "bogus_page/"
    @crawler.overdue_page.should be_nil
    @crawler.errors.should include(:login_page_not_found)
  end
   
  it 'handles login page with missing login form' do
    @crawler = BookWorm::CplCrawler.new('bogus', '345253')
    @crawler.start_url = TEST_SERVER + "/"
    @crawler.overdue_page.should be_nil
    @crawler.errors.should include(:missing_login_form)
  end
end