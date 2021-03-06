#encoding: UTF-8
require 'spec_helper'
require_relative 'integration_env'

describe 'Crawler and Parser together' do
  it 'gets the overdue items for valid username' do
    library_card = BookWorm::CplTest::LIBRARY_CARD_OK
    zip_code = BookWorm::CplTest::ZIP_CODE_OK
    crawler = BookWorm::CplCrawler.new(library_card, zip_code)
    crawler.start_url = TEST_SERVER + "mycpl/login/"
    parser = BookWorm::CplParser.new(:all => crawler.crawl.body)
    parser.overdue_items.size.should == 1
    item = parser.overdue_items.first
    item[:title].should == "Cría cuervos"
    item[:status].should == 'Overdue'
    item[:due_date].should == Date.parse('2009-11-04')
  end

  it 'fails login the for invalid username' do
    crawler = BookWorm::CplCrawler.new('bogus', '345253')
    crawler.start_url = TEST_SERVER + "mycpl/login/"
    crawler.overdue_page.should be_nil
    crawler.errors[:message].should =~ /Failed login/
  end

  it 'handles 404 login page' do
    crawler = BookWorm::CplCrawler.new('bogus', '345253')
    crawler.start_url = TEST_SERVER + "bogus_page/"
    crawler.overdue_page.should be_nil
    crawler.errors[:page_url].to_s.should == crawler.start_url
    crawler.errors[:message].should =~ /404/
  end
   
  it 'handles login page with missing login form' do
    crawler = BookWorm::CplCrawler.new('bogus', '345253')
    crawler.start_url = TEST_SERVER + "/"
    crawler.overdue_page.should be_nil
    crawler.errors[:message].should =~ /login form/
  end
end
