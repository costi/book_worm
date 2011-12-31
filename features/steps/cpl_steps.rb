Given /^a CPL patron with (\d+) checked out items$/ do |arg1|
  @library_card = LIBRARY_CARD_OK
  @zip_code = ZIP_CODE_OK
end

When /^I login to the website with his credentials$/ do
  pending # express the regexp above with the code you wish you had
end

