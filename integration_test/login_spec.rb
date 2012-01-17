require 'spec_helper'
require_relative 'integration_env'

describe 'Crawler and Parser together' do
  it 'gets the overdue items' do
    @library_card = BookWorm::CplTest::LIBRARY_CARD_OK
    @zip_code = BookWorm::CplTest::ZIP_CODE_OK
    @crawler = BookWorm::CplCrawler.new(@library_card, @zip_code)
    @crawler.start_url = "http://localhost:4567/mycpl/login/"
    @crawler.overdue_page.should_not be_nil
  end
end
