Given /^a CPL patron with (\d+) checked out items$/ do |arg1|
  @library_card = LIBRARY_CARD_OK
  @zip_code = ZIP_CODE_OK
end

When /^I login to the website with his credentials$/ do
  @crawler = BookWorm::CplCrawler.new(@library_card, @zip_code)
  @crawler.start_url = "http://localhost:4567/mycpl/login"
  @crawler.login!
end

Then /^I get to his homepage$/ do
  pending do
    @crawler.home_page.should_not be_nil
  end
end

